package com.example.demo.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.example.demo.dto.UsuarioDTO;
import com.example.demo.model.Usuario;
import com.example.demo.service.UsuarioService;

import jakarta.persistence.EntityNotFoundException;

@RestController
@RequestMapping("/usuarios")
public class UsuarioController {

    @Autowired
    private UsuarioService usuarioService;

    /**
     * Cria um novo usuário.
     */
    @PostMapping
    public ResponseEntity<Usuario> criarUsuario(@RequestBody UsuarioDTO dto) {
        try {
            Usuario criado = usuarioService.criarUsuario(dto);
            return ResponseEntity.ok(criado);
        } catch (IllegalArgumentException e) {
            return ResponseEntity.badRequest().body(null);
        }
    }

    /**
     * Lista todos os usuários.
     */
    @GetMapping
    public ResponseEntity<List<Usuario>> listarTodos() {
        List<Usuario> usuarios = usuarioService.listarTodosUsuarios();
        return ResponseEntity.ok(usuarios);
    }

    /**
     * Busca um usuário por ID.
     */
    @GetMapping("/{id}")
    public ResponseEntity<Usuario> buscarPorId(@PathVariable Long id) {
        try {
            Usuario u = usuarioService.buscarPorId(id);
            return ResponseEntity.ok(u);
        } catch (EntityNotFoundException e) {
            return ResponseEntity.notFound().build();
        }
    }

    /**
     * Busca um usuário por CPF.
     */
    @GetMapping("/cpf/{cpf}")
    public ResponseEntity<Usuario> buscarPorCpf(@PathVariable String cpf) {
        try {
            Usuario u = usuarioService.buscarPorCpf(cpf);
            return ResponseEntity.ok(u);
        } catch (EntityNotFoundException e) {
            return ResponseEntity.notFound().build();
        }
    }

    /**
     * Atualiza um usuário existente (por ID).
     */
    @PutMapping("/{id}")
    public ResponseEntity<Usuario> atualizarUsuario(
            @PathVariable Long id,
            @RequestBody UsuarioDTO dto
    ) {
        try {
            Usuario atualizado = usuarioService.atualizarUsuario(id, dto);
            return ResponseEntity.ok(atualizado);
        } catch (EntityNotFoundException e) {
            return ResponseEntity.notFound().build();
        } catch (IllegalArgumentException e) {
            return ResponseEntity.badRequest().body(null);
        }
    }

    /**
     * Exclui um usuário por ID. 
     * Ao final, retorna a lista atualizada de usuários ("organizar os usuários").
     */
    @DeleteMapping("/{id}")
    public ResponseEntity<List<Usuario>> excluirUsuario(@PathVariable Long id) {
        try {
            usuarioService.excluirUsuario(id);
            // Depois de excluir, retorna lista atualizada
            List<Usuario> listaAtualizada = usuarioService.listarTodosUsuarios();
            return ResponseEntity.ok(listaAtualizada);
        } catch (EntityNotFoundException e) {
            return ResponseEntity.notFound().build();
        }
    }
}
