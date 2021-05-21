import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/visitor.dart';

class ModelAstVisitor extends SimpleAstVisitor {
  @override
  visitExpressionStatement(ExpressionStatement node) {
    for (var child in node.childEntities) {
      print('${child.runtimeType} ${child.toString()}');
    }
    node.visitChildren(this);
    return super.visitExpressionStatement(node);
  }

  @override
  visitAnnotation(Annotation node) {
    // TODO: implement visitAnnotation
    return super.visitAnnotation(node);
  }

  @override
  visitMethodInvocation(MethodInvocation node) {
    for (var child in node.childEntities) {
      print('${child.runtimeType} ${child.toString()}');
    }
    node.visitChildren(this);
    return super.visitMethodInvocation(node);
  }

  @override
  visitFunctionExpression(FunctionExpression node) {
    // TODO: implement visitFunctionExpression
    for (var child in node.childEntities) {
      print('${child.runtimeType} ${child.toString()}');
    }
    node.visitChildren(this);
    return super.visitFunctionExpression(node);
  }

  @override
  visitBlockFunctionBody(BlockFunctionBody node) {
    print(node.toSource());
    for (var child in node.childEntities) {
      print('${child.runtimeType} ${child.toString()}');
    }
    node.visitChildren(this);
    return super.visitBlockFunctionBody(node);
  }

  @override
  visitBlock(Block node) {
    print(node.toSource());
    for (var child in node.childEntities) {
      print('${child.runtimeType} ${child.toString()}');
    }
    node.visitChildren(this);
    return super.visitBlock(node);
  }

  @override
  visitFunctionDeclarationStatement(FunctionDeclarationStatement node) {
    print(node.toSource());
    for (var child in node.childEntities) {
      print('${child.runtimeType} ${child.toString()}');
    }
    node.visitChildren(this);
    return super.visitFunctionDeclarationStatement(node);
  }

  @override
  visitFunctionDeclaration(FunctionDeclaration node) {
    print(node.toSource());
    for (var child in node.childEntities) {
      print('${child.runtimeType} ${child.toString()}');
    }
    node.visitChildren(this);
    return super.visitFunctionDeclaration(node);
  }
}

class ModelVisitor extends GeneralizingElementVisitor {
  @override
  visitElement(Element element) {
    // TODO: implement visitElement
    print("${element.runtimeType} runtimeType ${element.toString()}}");
    return super.visitElement(element);
  }
// @override
// visitFunctionElement(FunctionElement element) {
//   // TODO: implement visitFunctionElement
//   return super.visitFunctionElement(element);
// }
//
// @override
// visitMethodElement(MethodElement element) {
//   // TODO: implement visitMethodElement
//   return super.visitMethodElement(element);
// }
}
