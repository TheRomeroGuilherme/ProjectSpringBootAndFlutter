package com.example.demo.service;

import java.time.LocalDate;
import java.time.Period;
import java.util.List;
import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.example.demo.dto.UsuarioDTO;
import com.example.demo.model.Usuario;
import com.example.demo.repository.UsuarioRepository;

import jakarta.persistence.EntityNotFoundException;

@Service
public class UsuarioService {

    @Autowired
    private UsuarioRepository usuarioRepository;

    /**
     * Cria um novo usuário com base no DTO.
     * Validações:
     * - CPF não pode estar duplicado.
     * - Idade (a partir de dataNascimento) deve ser >= 18.
     * - Sexo deve ser "M" (mulher) ou "H" (homem).
     */
    public Usuario criarUsuario(UsuarioDTO dto) {
        // 1) CPF único
        if (usuarioRepository.existsByCpf(dto.getCpf())) {
            throw new IllegalArgumentException("Já existe usuário cadastrado com este CPF.");
        }

        // 2) Verifica idade >= 18
        LocalDate hoje = LocalDate.now();
        LocalDate nascimento = dto.getDataNascimento();
        if (nascimento == null) {
            throw new IllegalArgumentException("Data de nascimento inválida.");
        }
        int idade = Period.between(nascimento, hoje).getYears();
        if (idade < 18) {
            throw new IllegalArgumentException("Usuário deve ter pelo menos 18 anos.");
        }

        // 3) Sexo válido
        String sexo = dto.getSexo();
        if (sexo == null || (!sexo.equalsIgnoreCase("M") && !sexo.equalsIgnoreCase("H"))) {
            throw new IllegalArgumentException("Sexo inválido. Use 'M' para mulher ou 'H' para homem.");
        }

        // 4) Monta a entidade e salva
        Usuario novo = new Usuario();
        novo.setNomeCompleto(dto.getNomeCompleto());
        novo.setCpf(dto.getCpf());
        novo.setDataNascimento(dto.getDataNascimento());
        novo.setSexo(sexo.toUpperCase());
        novo.setDataCadastro(LocalDate.now()); 

        return usuarioRepository.save(novo);
    }

    /**
     * Retorna a lista de todos os usuários.
     */
    public List<Usuario> listarTodosUsuarios() {
        return usuarioRepository.findAll();
    }

    /**
     * Busca usuário por ID.
     * Joga EntityNotFoundException se não encontrar.
     */
    public Usuario buscarPorId(Long id) {
        Optional<Usuario> opt = usuarioRepository.findById(id);
        if (opt.isEmpty()) {
            throw new EntityNotFoundException("Usuário com id " + id + " não encontrado.");
        }
        return opt.get();
    }

    /**
     * Busca usuário por CPF.
     * Joga EntityNotFoundException se não encontrar.
     */
    public Usuario buscarPorCpf(String cpf) {
        Optional<Usuario> opt = usuarioRepository.findByCpf(cpf);
        if (opt.isEmpty()) {
            throw new EntityNotFoundException("Usuário com CPF " + cpf + " não encontrado.");
        }
        return opt.get();
    }

    /**
     * Atualiza dados de um usuário existente, identificado por ID.
     * Mesmas validações do criar (exceto checar duplicidade de CPF se for o mesmo CPF do próprio usuário).
     */
    public Usuario atualizarUsuario(Long id, UsuarioDTO dto) {
        // 1) Busca usuário existente
        Usuario existente = buscarPorId(id);

        // 2) Se o DTO tiver CPF diferente, verifica duplicidade
        String novoCpf = dto.getCpf();
        if (novoCpf == null || novoCpf.isBlank()) {
            throw new IllegalArgumentException("O CPF deve ser informado.");
        }
        if (!novoCpf.equals(existente.getCpf())) {
            // Tentou trocar o CPF: verifica se já existe outro
            if (usuarioRepository.existsByCpf(novoCpf)) {
                throw new IllegalArgumentException("Já existe outro usuário com este CPF.");
            }
            existente.setCpf(novoCpf);
        }

        // 3) Verifica idade >= 18
        LocalDate hoje = LocalDate.now();
        LocalDate nascimento = dto.getDataNascimento();
        if (nascimento == null) {
            throw new IllegalArgumentException("Data de nascimento inválida.");
        }
        int idade = Period.between(nascimento, hoje).getYears();
        if (idade < 18) {
            throw new IllegalArgumentException("Usuário deve ter pelo menos 18 anos.");
        }

        // 4) Sexo válido
        String sexo = dto.getSexo();
        if (sexo == null || (!sexo.equalsIgnoreCase("M") && !sexo.equalsIgnoreCase("H"))) {
            throw new IllegalArgumentException("Sexo inválido. Use 'M' para mulher ou 'H' para homem.");
        }

        // 5) Atualiza campos restantes
        existente.setNomeCompleto(dto.getNomeCompleto());
        existente.setDataNascimento(dto.getDataNascimento());
        existente.setSexo(sexo.toUpperCase());

        return usuarioRepository.save(existente);
    }

    /**
     * Exclui um usuário por ID.
     */
    // ADICIONE ESTE MÉTODO
    public void excluirUsuarioPorCpf(String cpf) {
        if (!usuarioRepository.existsByCpf(cpf)) {
            throw new EntityNotFoundException("Não existe usuário com CPF " + cpf + " para exclusão.");
        }
        usuarioRepository.deleteByCpf(cpf);
    }
}
