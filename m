From: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: dm log: struct log_write_super and padding (was: Re: dm: add log
 writes target)
Date: Sun, 19 Apr 2015 00:16:05 +0200
Message-ID: <CAMuHMdUfvo1V_2fYky9JmHXbSV0kJLt7VmayW2=okNCfaQd0DQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Josef Bacik <jbacik@fb.com>, Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>
Cc: dm-devel@redhat.com, Neil Brown <neilb@suse.de>, linux-raid@vger.kernel.org, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-Id: dm-devel.ids

On Sat, Apr 18, 2015 at 2:34 PM, Linux Kernel Mailing List
<linux-kernel@vger.kernel.org> wrote:
> Gitweb:     http://git.kernel.org/linus/;a=commit;h=0e9cebe724597a76ab1b0ebc0a21e16f7db11b47
> Commit:     0e9cebe724597a76ab1b0ebc0a21e16f7db11b47

> --- /dev/null
> +++ b/drivers/md/dm-log-writes.c
> @@ -0,0 +1,825 @@

> +/*
> + * Basic info about the log for userspace.
> + */
> +struct log_write_super {
> +       __le64 magic;
> +       __le64 version;
> +       __le64 nr_entries;
> +       __le32 sectorsize;

Should there be an explicit padding of 4 bytes?
Does anything assume that sizeof(struct log_write_super) is always 4 * 8?

On architectures where the natural alignment of 64-bit quantities is less
than 8 bytes, sizeof(struct log_write_super) is smaller than 32 bytes
(e.g. on m68k it's 28).

> +};

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
