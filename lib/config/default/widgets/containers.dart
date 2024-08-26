import 'package:flutter/material.dart';
import 'package:habit_on_assig/config/default/widgets/text.dart';

class ButtonDef extends StatelessWidget {
  const ButtonDef({
    super.key,
    this.things,
    this.height,
    this.width,
    this.onTap,
  });
  final Widget? things;
  final VoidCallback? onTap;
  final double? height;
  final double? width;
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onTap ?? () {},
      style: ButtonStyle(
        minimumSize: WidgetStatePropertyAll(
          Size(width ?? 200, height ?? 30),
        ),
      ),
      child: things ?? const TextDef('Example'),
    );
  }
}

class SpaceX extends StatelessWidget {
  const SpaceX(this.space, {super.key});
  final double? space;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: space ?? 20,
    );
  }
}

class SpaceY extends StatelessWidget {
  const SpaceY(this.space, {super.key});
  final double? space;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: space ?? 20,
    );
  }
}

class CustomContainer extends StatelessWidget {
  final Widget? child;
  final Color? color;
  final BorderRadiusGeometry? borderRadius;
  final BoxShadow? boxShadow;
  final Border? border;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double? width;
  final double? height;
  final AlignmentGeometry? alignment;
  final Gradient? gradient;
  final VoidCallback? ontap;
  const CustomContainer({
    super.key,
    this.child,
    this.color,
    this.borderRadius,
    this.boxShadow,
    this.border,
    this.padding,
    this.margin,
    this.width,
    this.height,
    this.alignment,
    this.gradient,
    this.ontap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: ontap,
      child: Container(
        alignment: alignment,
        padding: padding,
        margin: margin,
        width: width ?? 150,
        height: height ?? 350,
        decoration: BoxDecoration(
          color: color ?? Theme.of(context).primaryColor.withOpacity(0.1),
          borderRadius: borderRadius ?? BorderRadius.circular(20),
          boxShadow: boxShadow != null ? [boxShadow!] : null,
          border: border,
          gradient: gradient ??
              const LinearGradient(
                colors: [Colors.blue, Colors.purple],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
        ),
        child: child,
      ),
    );
  }
}
