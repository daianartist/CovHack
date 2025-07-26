import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class QrScannerScreen extends StatefulWidget {
  const QrScannerScreen({super.key});

  @override
  State<QrScannerScreen> createState() => _QrScannerScreenState();
}

class _QrScannerScreenState extends State<QrScannerScreen>
    with TickerProviderStateMixin {
  late AnimationController _scanLineController;
  late Animation<double> _scanLineAnimation;
  bool _isFlashOn = false;
  bool _isScanning = true;

  @override
  void initState() {
    super.initState();
    _scanLineController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _scanLineAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _scanLineController,
      curve: Curves.easeInOut,
    ));
    _scanLineController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _scanLineController.dispose();
    super.dispose();
  }

  void _toggleFlash() {
    setState(() {
      _isFlashOn = !_isFlashOn;
    });
    HapticFeedback.lightImpact();
  }

  void _onQrDetected(String qrData) {
    HapticFeedback.heavyImpact();
    setState(() {
      _isScanning = false;
    });
    
    // Показываем результат сканирования
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => _buildResultBottomSheet(qrData),
    ).then((_) {
      setState(() {
        _isScanning = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(
            Icons.close_rounded,
            color: Colors.white,
            size: 28,
          ),
        ),
        title: const Text(
          'QR Scanner',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: _toggleFlash,
            icon: Icon(
              _isFlashOn ? Icons.flash_on_rounded : Icons.flash_off_rounded,
              color: _isFlashOn ? Colors.yellow : Colors.white,
              size: 28,
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          // Camera Preview (симуляция)
          _buildCameraPreview(),
          
          // Overlay с рамкой для сканирования
          _buildScannerOverlay(),
          
          // Инструкции
          _buildInstructions(),
          
       
        ],
      ),
    );
  }

  Widget _buildCameraPreview() {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFF1a1a1a),
            Color(0xFF2d2d2d),
            Color(0xFF1a1a1a),
          ],
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.videocam_outlined,
              size: 100,
              color: Colors.white24,
            ),
            const SizedBox(height: 20),
        
          ],
        ),
      ),
    );
  }

  Widget _buildScannerOverlay() {
    return Stack(
      children: [
        // Затемнение вокруг области сканирования
        Container(
          color: Colors.black54,
          child: Column(
            children: [
              Expanded(flex: 2, child: Container()),
              Container(
                height: 250,
                margin: const EdgeInsets.symmetric(horizontal: 50),
                child: Row(
                  children: [
                    Expanded(child: Container()),
                    Container(
                      width: 250,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.transparent),
                      ),
                    ),
                    Expanded(child: Container()),
                  ],
                ),
              ),
              Expanded(flex: 2, child: Container()),
            ],
          ),
        ),
        
        // Рамка сканера
        Center(
          child: Container(
            width: 250,
            height: 250,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.transparent, width: 2),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Stack(
              children: [
                // Углы рамки
                ...List.generate(4, (index) => _buildCorner(index)),
                
                // Анимированная линия сканирования
                if (_isScanning) _buildScanLine(),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCorner(int index) {
    final corners = [
      // Левый верхний
      const Positioned(
        top: 0,
        left: 0,
        child: _CornerWidget(
          alignment: Alignment.topLeft,
        ),
      ),
      // Правый верхний
      const Positioned(
        top: 0,
        right: 0,
        child: _CornerWidget(
          alignment: Alignment.topRight,
        ),
      ),
      // Левый нижний
      const Positioned(
        bottom: 0,
        left: 0,
        child: _CornerWidget(
          alignment: Alignment.bottomLeft,
        ),
      ),
      // Правый нижний
      const Positioned(
        bottom: 0,
        right: 0,
        child: _CornerWidget(
          alignment: Alignment.bottomRight,
        ),
      ),
    ];
    return corners[index];
  }

  Widget _buildScanLine() {
    return AnimatedBuilder(
      animation: _scanLineAnimation,
      builder: (context, child) {
        return Positioned(
          top: _scanLineAnimation.value * 210 + 20,
          left: 20,
          right: 20,
          child: Container(
            height: 3,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [
                  Colors.transparent,
                  Color(0xFF3B82F6),
                  Colors.transparent,
                ],
              ),
              borderRadius: BorderRadius.circular(2),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF3B82F6).withOpacity(0.5),
                  blurRadius: 8,
                  spreadRadius: 1,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildInstructions() {
    return Positioned(
      top: MediaQuery.of(context).size.height * 0.15,
      left: 0,
      right: 0,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.black45,
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Text(
              'Наведите камеру на QR код',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'QR код должен полностью помещаться в рамку',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  
  Widget _buildResultBottomSheet(String qrData) {
    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Хендлер
          Container(
            margin: const EdgeInsets.only(top: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                // Иконка успеха
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.qr_code_rounded,
                    color: Colors.green,
                    size: 48,
                  ),
                ),
                
                const SizedBox(height: 20),
                
                const Text(
                  'QR код успешно отсканирован!',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                  textAlign: TextAlign.center,
                ),
                
                const SizedBox(height: 16),
                
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    qrData,
                    style: const TextStyle(
                      fontSize: 14,
                      fontFamily: 'monospace',
                      color: Colors.black87,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                
                const SizedBox(height: 24),
                
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text('Сканировать ещё'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF3B82F6),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          'Готово',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  
}

class _CornerWidget extends StatelessWidget {
  final Alignment alignment;
  
  const _CornerWidget({required this.alignment});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 30,
      height: 30,
      decoration: BoxDecoration(
        border: Border(
          top: alignment == Alignment.topLeft || alignment == Alignment.topRight
              ? const BorderSide(color: Color(0xFF3B82F6), width: 4)
              : BorderSide.none,
          bottom: alignment == Alignment.bottomLeft || alignment == Alignment.bottomRight
              ? const BorderSide(color: Color(0xFF3B82F6), width: 4)
              : BorderSide.none,
          left: alignment == Alignment.topLeft || alignment == Alignment.bottomLeft
              ? const BorderSide(color: Color(0xFF3B82F6), width: 4)
              : BorderSide.none,
          right: alignment == Alignment.topRight || alignment == Alignment.bottomRight
              ? const BorderSide(color: Color(0xFF3B82F6), width: 4)
              : BorderSide.none,
        ),
      ),
    );
  }
}
