"""
HarmonyScan Downloader - Qt Models
Data models for QML views
"""

from typing import List, Any
from PyQt6.QtCore import QAbstractListModel, Qt, QModelIndex, pyqtSlot, pyqtSignal


class ChapterListModel(QAbstractListModel):
    """Model for chapter list in QML."""
    
    # Define roles for QML access
    TitleRole = Qt.ItemDataRole.UserRole + 1
    UrlRole = Qt.ItemDataRole.UserRole + 2
    NumberRole = Qt.ItemDataRole.UserRole + 3
    ThumbnailRole = Qt.ItemDataRole.UserRole + 4
    ViewsRole = Qt.ItemDataRole.UserRole + 5
    SelectedRole = Qt.ItemDataRole.UserRole + 6
    
    # Signals
    selectionChanged = pyqtSignal()
    
    def __init__(self, parent=None):
        super().__init__(parent)
        self._chapters: List[dict] = []
    
    def rowCount(self, parent=QModelIndex()) -> int:
        return len(self._chapters)
    
    def data(self, index: QModelIndex, role: int = Qt.ItemDataRole.DisplayRole) -> Any:
        if not index.isValid() or index.row() >= len(self._chapters):
            return None
        
        chapter = self._chapters[index.row()]
        
        if role == self.TitleRole:
            return chapter.get("title", "")
        elif role == self.UrlRole:
            return chapter.get("url", "")
        elif role == self.NumberRole:
            return chapter.get("number", 0)
        elif role == self.ThumbnailRole:
            return chapter.get("thumbnail", "")
        elif role == self.ViewsRole:
            return chapter.get("views", 0)
        elif role == self.SelectedRole:
            return chapter.get("selected", False)
        elif role == Qt.ItemDataRole.DisplayRole:
            return chapter.get("title", "")
        
        return None
    
    def setData(self, index: QModelIndex, value: Any, role: int = Qt.ItemDataRole.EditRole) -> bool:
        if not index.isValid() or index.row() >= len(self._chapters):
            return False
        
        if role == self.SelectedRole:
            self._chapters[index.row()]["selected"] = value
            self.dataChanged.emit(index, index, [role])
            self.selectionChanged.emit()
            return True
        
        return False
    
    def roleNames(self) -> dict:
        return {
            self.TitleRole: b"title",
            self.UrlRole: b"url",
            self.NumberRole: b"number",
            self.ThumbnailRole: b"thumbnail",
            self.ViewsRole: b"views",
            self.SelectedRole: b"selected",
        }
    
    @pyqtSlot(list)
    def setChapters(self, chapters: list):
        """Set the chapter list."""
        self.beginResetModel()
        self._chapters = chapters
        self.endResetModel()
        self.selectionChanged.emit()
    
    @pyqtSlot()
    def selectAll(self):
        """Select all chapters."""
        for chapter in self._chapters:
            chapter["selected"] = True
        self.dataChanged.emit(
            self.index(0, 0),
            self.index(len(self._chapters) - 1, 0),
            [self.SelectedRole]
        )
        self.selectionChanged.emit()
    
    @pyqtSlot()
    def clearSelection(self):
        """Clear all selections."""
        for chapter in self._chapters:
            chapter["selected"] = False
        self.dataChanged.emit(
            self.index(0, 0),
            self.index(len(self._chapters) - 1, 0),
            [self.SelectedRole]
        )
        self.selectionChanged.emit()
    
    @pyqtSlot(int)
    def toggleSelection(self, index: int):
        """Toggle selection for a chapter at given index."""
        if 0 <= index < len(self._chapters):
            self._chapters[index]["selected"] = not self._chapters[index]["selected"]
            model_index = self.index(index, 0)
            self.dataChanged.emit(model_index, model_index, [self.SelectedRole])
            self.selectionChanged.emit()
    
    @pyqtSlot(result=list)
    def getSelectedChapters(self) -> list:
        """Get list of selected chapters."""
        return [ch for ch in self._chapters if ch.get("selected", False)]
    
    @pyqtSlot(result=int)
    def selectedCount(self) -> int:
        """Get count of selected chapters."""
        return sum(1 for ch in self._chapters if ch.get("selected", False))
    
    @pyqtSlot()
    def clear(self):
        """Clear all chapters."""
        self.beginResetModel()
        self._chapters = []
        self.endResetModel()
        self.selectionChanged.emit()
