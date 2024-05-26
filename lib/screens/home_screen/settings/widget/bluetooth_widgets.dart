import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../constants/style_manager.dart';
import '../../../widget/rounded_button_widget.dart';

class ScanResultTile extends StatefulWidget {
  const ScanResultTile({Key? key, required this.result, this.onTap,required this.isConnect}) : super(key: key);

  final ScanResult result;
  final VoidCallback? onTap;
  final bool isConnect;

  @override
  State<ScanResultTile> createState() => _ScanResultTileState();
}

class _ScanResultTileState extends State<ScanResultTile> {
  Widget _buildTitle(BuildContext context) {
    if (widget.result.device.localName.isNotEmpty) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            widget.result.device.localName,
            overflow: TextOverflow.ellipsis,
            style:  getSemiBoldStyle(color: Colors.black),
          ),
          Text(
            widget.result.device.remoteId.toString(),
            style: getSemiBoldStyle(color: Colors.black),
          )
        ],
      );
    } else {
      return Text(widget.result.device.remoteId.toString(),style:  getSemiBoldStyle(color: Colors.black),);
    }
  }

  Widget _buildAdvRow(BuildContext context, String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(title, style:  getSemiBoldStyle(color: Colors.black)),
          const SizedBox(
            width: 12.0,
          ),
          Expanded(
            child: Text(
              value,
              style:  getSemiBoldStyle(color: Colors.black),
              softWrap: true,
            ),
          ),
        ],
      ),
    );
  }

  String getNiceHexArray(List<int> bytes) {
    return '[${bytes.map((i) => i.toRadixString(16).padLeft(2, '0')).join(', ')}]'.toUpperCase();
  }

  String getNiceManufacturerData(Map<int, List<int>> data) {
    if (data.isEmpty) {
      return 'N/A';
    }
    List<String> res = [];
    data.forEach((id, bytes) {
      res.add('${id.toRadixString(16).toUpperCase()}: ${getNiceHexArray(bytes)}');
    });
    return res.join(', ');
  }

  String getNiceServiceData(Map<String, List<int>> data) {
    if (data.isEmpty) {
      return 'N/A';
    }
    List<String> res = [];
    data.forEach((id, bytes) {
      res.add('${id.toUpperCase()}: ${getNiceHexArray(bytes)}');
    });
    return res.join(', ');
  }

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: _buildTitle(context),
      leading: Text(widget.result.rssi.toString(),style: getSemiBoldStyle(color: Colors.black),),
      trailing: CustomButton(
        width: 110.w,
        height:50.h,
        onTap:  (widget.result.advertisementData.connectable) ? widget.onTap : null,
        title: widget.isConnect ? "Connected" :"Connect",
      ),
      children: <Widget>[
        _buildAdvRow(context, 'Complete Local Name', widget.result.advertisementData.localName),
        _buildAdvRow(context, 'Tx Power Level', '${widget.result.advertisementData.txPowerLevel ?? 'N/A'}'),
        _buildAdvRow(context, 'Manufacturer Data', getNiceManufacturerData(widget.result.advertisementData.manufacturerData)),
        _buildAdvRow(
            context,
            'Service UUIDs',
            (widget.result.advertisementData.serviceUuids.isNotEmpty)
                ? widget.result.advertisementData.serviceUuids.join(', ').toUpperCase()
                : 'N/A'),

      ],
    );
  }
}

class ServiceTile extends StatelessWidget {
  final BluetoothService service;
  final List<CharacteristicTile> characteristicTiles;

  const ServiceTile({Key? key, required this.service, required this.characteristicTiles}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (characteristicTiles.isNotEmpty) {
      return ExpansionTile(
        title: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Text('Service'),
            Text('0x${service.serviceUuid.toString().toUpperCase()}',
                style: Theme.of(context)
                    .textTheme
                    .bodyLarge
                    ?.copyWith(color: Theme.of(context).textTheme.bodySmall?.color))
          ],
        ),
        children: characteristicTiles,
      );
    } else {
      return ListTile(
        title: const Text('Service'),
        subtitle: Text('0x${service.serviceUuid.toString().toUpperCase()}'),
      );
    }
  }
}

class CharacteristicTile extends StatefulWidget {
  final BluetoothCharacteristic characteristic;
  final List<DescriptorTile> descriptorTiles;
  final Future<void> Function()? onReadPressed;
  final Future<void> Function()? onWritePressed;
  final Future<void> Function()? onNotificationPressed;

  const CharacteristicTile(
      {Key? key,
        required this.characteristic,
        required this.descriptorTiles,
        this.onReadPressed,
        this.onWritePressed,
        this.onNotificationPressed})
      : super(key: key);

  @override
  State<CharacteristicTile> createState() => _CharacteristicTileState();
}

class _CharacteristicTileState extends State<CharacteristicTile> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<int>>(
      stream: widget.characteristic.onValueReceived,
      initialData: widget.characteristic.lastValue,
      builder: (context, snapshot) {
        final List<int>? value = snapshot.data;
        return ExpansionTile(
          title: ListTile(
            title: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const Text('Characteristic'),
                Text(
                  '0x${widget.characteristic.characteristicUuid.toString().toUpperCase()}',
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge
                      ?.copyWith(color: Theme.of(context).textTheme.bodySmall?.color),
                ),
                Row(
                  children: [
                    if (widget.characteristic.properties.read)
                      TextButton(
                          child: Text("Read"),
                          onPressed: () async {
                            await widget.onReadPressed!();
                            setState(() {});
                          }),
                    if (widget.characteristic.properties.write)
                      TextButton(
                          child: Text(widget.characteristic.properties.writeWithoutResponse ? "WriteNoResp" : "Write"),
                          onPressed: () async {
                            await widget.onWritePressed!();
                            setState(() {});
                          }),
                    if (widget.characteristic.properties.notify || widget.characteristic.properties.indicate)
                      TextButton(
                          child: Text(widget.characteristic.isNotifying ? "Unsubscribe" : "Subscribe"),
                          onPressed: () async {
                            await widget.onNotificationPressed!();
                            setState(() {});
                          })
                  ],
                )
              ],
            ),
            subtitle: Text(value.toString()),
            contentPadding: const EdgeInsets.all(0.0),
          ),
          children: widget.descriptorTiles,
        );
      },
    );
  }
}

class DescriptorTile extends StatelessWidget {
  final BluetoothDescriptor descriptor;
  final VoidCallback? onReadPressed;
  final VoidCallback? onWritePressed;

  const DescriptorTile({Key? key, required this.descriptor, this.onReadPressed, this.onWritePressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Text('Descriptor'),
          Text('0x${descriptor.descriptorUuid.toString().toUpperCase()}',
              style:
              Theme.of(context).textTheme.bodyLarge?.copyWith(color: Theme.of(context).textTheme.bodySmall?.color))
        ],
      ),
      subtitle: StreamBuilder<List<int>>(
        stream: descriptor.onValueReceived,
        initialData: descriptor.lastValue,
        builder: (c, snapshot) => Text(snapshot.data.toString()),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          IconButton(
            icon: Icon(
              Icons.file_download,
              color: Theme.of(context).iconTheme.color?.withOpacity(0.5),
            ),
            onPressed: onReadPressed,
          ),
          IconButton(
            icon: Icon(
              Icons.file_upload,
              color: Theme.of(context).iconTheme.color?.withOpacity(0.5),
            ),
            onPressed: onWritePressed,
          )
        ],
      ),
    );
  }
}

class AdapterStateTile extends StatelessWidget {
  const AdapterStateTile({Key? key, required this.adapterState}) : super(key: key);

  final BluetoothAdapterState adapterState;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.redAccent,
      child: ListTile(
        title: Text(
          'Bluetooth adapter is ${adapterState.toString().split(".").last}',
          style: Theme.of(context).primaryTextTheme.titleSmall,
        ),
        trailing: Icon(
          Icons.error,
          color: Theme.of(context).primaryTextTheme.titleSmall?.color,
        ),
      ),
    );
  }
}

SnackBar snackBarGood(String message) {
  return SnackBar(content: Text(message), backgroundColor: Colors.blue);
}

SnackBar snackBarFail(String message) {
  return SnackBar(content: Text(message), backgroundColor: Colors.red);
}