package com.example.demo.model;

import java.time.LocalDate;
import java.time.Period;

import com.example.demo.dto.UsuarioDTO;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.Table;
import jakarta.persistence.Transient;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Entity
@Table(name = "usuarios")
@Data
@NoArgsConstructor
@AllArgsConstructor
public class Usuario {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "nome_completo", nullable = false)
    private String nomeCompleto;

    @Column(name = "cpf", nullable = false, unique = true, length = 11)
    private String cpf;

    @Column(name = "data_nascimento", nullable = false)
    private LocalDate dataNascimento;

    @Column(name = "sexo", nullable = false, length = 1)
    private String sexo;

    
    @Transient
    public int getIdade() {
        if (this.dataNascimento == null) {
            return 0;
        }
        return Period.between(this.dataNascimento, LocalDate.now()).getYears();
    }

    public void atualizarCom(UsuarioDTO dto) {
        this.nomeCompleto = dto.getNomeCompleto();
        this.dataNascimento = dto.getDataNascimento();
        this.sexo = dto.getSexo();
        // Observação: se fosse permitido atualizar CPF, retirar comentário abaixo;
        // por ora, mantém o CPF original para evitar duplicidade. 
        // this.cpf = dto.getCpf();
    }
}
