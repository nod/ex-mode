GlobalExState = require './global-ex-state'
ExState = require './ex-state'
Ex = require './ex'
{Disposable, CompositeDisposable} = require 'event-kit'

module.exports = ExMode =
  activate: (state) ->
    @globalExState = new GlobalExState
    @disposables = new CompositeDisposable
    @exStates = new WeakMap

    @disposables.add atom.workspace.observeTextEditors (editor) =>
      return if editor.mini

      element = atom.views.getView(editor)

      if not @exStates.get(editor)
        exState = new ExState(
          element,
          @globalExState
        )

        @exStates.set(editor, exState)

        @disposables.add new Disposable =>
          exState.destroy()

  deactivate: ->
    @disposables.dispose()

  provideEx: ->
    registerCommand: Ex.registerCommand.bind(Ex)

  consumeVim: (vim) ->
    console.log vim
    @vim = vim
