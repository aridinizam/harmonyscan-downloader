"""
HarmonyScan Downloader - GUI Entry Point
PyQt6 + QML Modern Interface
"""

import sys
import os
from pathlib import Path

# Add project root to path
PROJECT_ROOT = Path(__file__).parent.parent
sys.path.insert(0, str(PROJECT_ROOT))

from PyQt6.QtWidgets import QApplication
from PyQt6.QtQml import QQmlApplicationEngine, qmlRegisterType
from PyQt6.QtCore import QUrl, Qt
from PyQt6.QtGui import QIcon

from gui.backend.bridge import MangaBridge
from gui.backend.models import ChapterListModel


def main():
    """Launch the HarmonyScan GUI application."""
    # Enable High DPI scaling
    os.environ["QT_AUTO_SCREEN_SCALE_FACTOR"] = "1"
    
    app = QApplication(sys.argv)
    app.setApplicationName("HarmonyScan Downloader")
    app.setOrganizationName("HarmonyScan")
    app.setOrganizationDomain("harmony-scan.fr")
    
    # Set application icon if exists
    icon_path = PROJECT_ROOT / "assets" / "logo.png"
    if icon_path.exists():
        app.setWindowIcon(QIcon(str(icon_path)))
    
    # Create QML engine
    engine = QQmlApplicationEngine()
    
    # Create and register backend bridge
    bridge = MangaBridge()
    engine.rootContext().setContextProperty("backend", bridge)
    
    # Create and register chapter model
    chapter_model = ChapterListModel()
    engine.rootContext().setContextProperty("chapterModel", chapter_model)
    
    # Connect bridge to model
    bridge.chaptersLoaded.connect(chapter_model.setChapters)
    
    # Get QML path
    qml_path = Path(__file__).parent / "qml" / "main.qml"
    
    # Load main QML file
    engine.load(QUrl.fromLocalFile(str(qml_path)))
    
    if not engine.rootObjects():
        print("Error: Failed to load QML")
        sys.exit(-1)
    
    # Run application
    sys.exit(app.exec())


if __name__ == "__main__":
    main()
