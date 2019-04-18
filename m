From: Alexander Potapenko <glider@google.com>
Subject: Re: [patch V2 14/29] dm bufio: Simplify stack trace retrieval
Date: Thu, 18 Apr 2019 12:44:08 +0200
Message-ID: <CAG_fn=WP9+bVv9hedoaTzWK+xBzedxaGJGVOPnF0o115s-oWvg@mail.gmail.com>
References: <20190418084119.056416939@linutronix.de> <20190418084254.361284697@linutronix.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190418084254.361284697@linutronix.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>, Josh Poimboeuf <jpoimboe@redhat.com>, x86@kernel.org, Andy Lutomirski <luto@kernel.org>, Steven Rostedt <rostedt@goodmis.org>, dm-devel@redhat.com, Mike Snitzer <snitzer@redhat.com>, Alasdair Kergon <agk@redhat.com>, Alexey Dobriyan <adobriyan@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, Pekka Enberg <penberg@kernel.org>, Linux Memory Management List <linux-mm@kvack.org>, David Rientjes <rientjes@google.com>, Christoph Lameter <cl@linux.com>, Catalin Marinas <catalin.marinas@arm.com>, Dmitry Vyukov <dvyukov@google.com>, Andrey Ryabinin <aryabinin@virtuozzo.com>, kasan-dev <kasan-dev@googlegroups.com>, Mike Rapoport <rppt@linux.vnet.ibm.com>, Akinobu Mita <akinobu.mita@gmail.com>, iommu@lists.linu
List-Id: dm-devel.ids

On Thu, Apr 18, 2019 at 11:06 AM Thomas Gleixner <tglx@linutronix.de> wrote=
:
>
> Replace the indirection through struct stack_trace with an invocation of
> the storage array based interface.
>
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> Cc: dm-devel@redhat.com
> Cc: Mike Snitzer <snitzer@redhat.com>
> Cc: Alasdair Kergon <agk@redhat.com>
> ---
>  drivers/md/dm-bufio.c |   15 ++++++---------
>  1 file changed, 6 insertions(+), 9 deletions(-)
>
> --- a/drivers/md/dm-bufio.c
> +++ b/drivers/md/dm-bufio.c
> @@ -150,7 +150,7 @@ struct dm_buffer {
>         void (*end_io)(struct dm_buffer *, blk_status_t);
>  #ifdef CONFIG_DM_DEBUG_BLOCK_STACK_TRACING
>  #define MAX_STACK 10
> -       struct stack_trace stack_trace;
> +       unsigned int stack_len;
>         unsigned long stack_entries[MAX_STACK];
>  #endif
>  };
> @@ -232,11 +232,7 @@ static DEFINE_MUTEX(dm_bufio_clients_loc
>  #ifdef CONFIG_DM_DEBUG_BLOCK_STACK_TRACING
>  static void buffer_record_stack(struct dm_buffer *b)
>  {
> -       b->stack_trace.nr_entries =3D 0;
> -       b->stack_trace.max_entries =3D MAX_STACK;
> -       b->stack_trace.entries =3D b->stack_entries;
> -       b->stack_trace.skip =3D 2;
> -       save_stack_trace(&b->stack_trace);
> +       b->stack_len =3D stack_trace_save(b->stack_entries, MAX_STACK, 2)=
;
As noted in one of similar patches before, can we have an inline
comment to indicate what does this "2" stand for?
>  }
>  #endif
>
> @@ -438,7 +434,7 @@ static struct dm_buffer *alloc_buffer(st
>         adjust_total_allocated(b->data_mode, (long)c->block_size);
>
>  #ifdef CONFIG_DM_DEBUG_BLOCK_STACK_TRACING
> -       memset(&b->stack_trace, 0, sizeof(b->stack_trace));
> +       b->stack_len =3D 0;
>  #endif
>         return b;
>  }
> @@ -1520,8 +1516,9 @@ static void drop_buffers(struct dm_bufio
>                         DMERR("leaked buffer %llx, hold count %u, list %d=
",
>                               (unsigned long long)b->block, b->hold_count=
, i);
>  #ifdef CONFIG_DM_DEBUG_BLOCK_STACK_TRACING
> -                       print_stack_trace(&b->stack_trace, 1);
> -                       b->hold_count =3D 0; /* mark unclaimed to avoid B=
UG_ON below */
> +                       stack_trace_print(b->stack_entries, b->stack_len,=
 1);
> +                       /* mark unclaimed to avoid BUG_ON below */
> +                       b->hold_count =3D 0;
>  #endif
>                 }
>
>
>


--=20
Alexander Potapenko
Software Engineer

Google Germany GmbH
Erika-Mann-Stra=C3=9Fe, 33
80636 M=C3=BCnchen

Gesch=C3=A4ftsf=C3=BChrer: Paul Manicle, Halimah DeLaine Prado
Registergericht und -nummer: Hamburg, HRB 86891
Sitz der Gesellschaft: Hamburg
