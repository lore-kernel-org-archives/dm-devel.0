From: Stuart Little <achirvasub@gmail.com>
Subject: Re: PROBLEM: 5.9.0-rc6 fails =?utf-8?Q?to_?=
 =?utf-8?Q?compile_due_to_'redefinition_of_=E2=80=98dax=5Fsupported?=
 =?utf-8?B?4oCZJw==?=
Date: Mon, 21 Sep 2020 06:29:33 -0400
Message-ID: <20200921102933.GF3027080@arch-chirva.localdomain>
References: <20200921010359.GO3027113@arch-chirva.localdomain>
 <CA+G9fYtCg2KjdB2oBUDJ2DKAzUxq3u8ZnMY9Et-RG9Pnrmuf9w@mail.gmail.com>
 <20200921073218.GA3142611@kroah.com>
 <20200921095035.GC5862@quack2.suse.cz>
 <CAMuHMdX871H5zqgb877Tw3N6PczpXTvnbCGRt++4udNpf8Oftg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAMuHMdX871H5zqgb877Tw3N6PczpXTvnbCGRt++4udNpf8Oftg@mail.gmail.com>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Jan Kara <jack@suse.cz>, Greg KH <gregkh@linuxfoundation.org>, Naresh Kamboju <naresh.kamboju@linaro.org>, Dan Williams <dan.j.williams@intel.com>, Vishal Verma <vishal.l.verma@intel.com>, Dave Jiang <dave.jiang@intel.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, kernel list <linux-kernel@vger.kernel.org>, linux- stable <stable@vger.kernel.org>, Adrian Huang <ahuang12@lenovo.com>, Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com, Ira Weiny <ira.weiny@intel.com>, Mikulas Patocka <mpatocka@redhat.com>, lkft-triage@lists.linaro.org
List-Id: dm-devel.ids

Confirmed: the patch fixed the build for me as well; thank you! 

On Mon, Sep 21, 2020 at 12:08:43PM +0200, Geert Uytterhoeven wrote:
> Hi Honza,
> 
> On Mon, Sep 21, 2020 at 11:54 AM Jan Kara <jack@suse.cz> wrote:
> > On Mon 21-09-20 09:32:18, Greg KH wrote:
> > > On Mon, Sep 21, 2020 at 11:34:17AM +0530, Naresh Kamboju wrote:
> > > > On Mon, 21 Sep 2020 at 06:34, Stuart Little <achirvasub@gmail.com> wrote:
> > > > > I am trying to compile for an x86_64 machine (Intel(R) Core(TM) i7-7500U CPU @ 2.70GHz). The config file I am currently using is at
> > > > >
> > > > > https://termbin.com/xin7
> > > > >
> > > > > The build for 5.9.0-rc6 fails with the following errors:
> > > > >
> > > >
> > > > arm and mips allmodconfig build breaks due to this error.
> > >
> > > all my local builds are breaking now too with this :(
> > >
> > > Was there a proposed patch anywhere for this?
> >
> > Attached patch should fix the build breakage. I'm sorry for that.
> 
> Thanks, this fixes my m68k build issues:
> Tested-by: Geert Uytterhoeven <geert@linux-m68k.org>
> 
> Gr{oetje,eeting}s,
> 
>                         Geert
> 
> -- 
> Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org
> 
> In personal conversations with technical people, I call myself a hacker. But
> when I'm talking to journalists I just say "programmer" or something like that.
>                                 -- Linus Torvalds
