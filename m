From: Naresh Kamboju <naresh.kamboju@linaro.org>
Subject: =?UTF-8?B?UmU6IFBST0JMRU06IDUuOS4wLXJjNiBmYWlscyB0byBjb21waWxlIGR1ZSB0byAncmVkZQ==?=
        =?UTF-8?B?ZmluaXRpb24gb2Yg4oCYZGF4X3N1cHBvcnRlZOKAmSc=?=
Date: Mon, 21 Sep 2020 11:34:17 +0530
Message-ID: <CA+G9fYtCg2KjdB2oBUDJ2DKAzUxq3u8ZnMY9Et-RG9Pnrmuf9w@mail.gmail.com>
References: <20200921010359.GO3027113@arch-chirva.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20200921010359.GO3027113@arch-chirva.localdomain>
To: Stuart Little <achirvasub@gmail.com>
Cc: Dan Williams <dan.j.williams@intel.com>, Vishal Verma <vishal.l.verma@intel.com>, Dave Jiang <dave.jiang@intel.com>, linux-nvdimm@lists.01.org, kernel list <linux-kernel@vger.kernel.org>, linux- stable <stable@vger.kernel.org>, Adrian Huang <ahuang12@lenovo.com>, Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com, Ira Weiny <ira.weiny@intel.com>, mpatocka@redhat.com, lkft-triage@lists.linaro.org, Jan Kara <jack@suse.cz>
List-Id: dm-devel.ids

On Mon, 21 Sep 2020 at 06:34, Stuart Little <achirvasub@gmail.com> wrote:
>
> I am trying to compile for an x86_64 machine (Intel(R) Core(TM) i7-7500U =
CPU @ 2.70GHz). The config file I am currently using is at
>
> https://termbin.com/xin7
>
> The build for 5.9.0-rc6 fails with the following errors:
>

arm and mips allmodconfig build breaks due to this error.

>
> drivers/dax/super.c:325:6: error: redefinition of =E2=80=98dax_supported=
=E2=80=99
>   325 | bool dax_supported(struct dax_device *dax_dev, struct block_devic=
e *bdev,
>       |      ^~~~~~~~~~~~~
> In file included from drivers/dax/super.c:16:
> ./include/linux/dax.h:162:20: note: previous definition of =E2=80=98dax_s=
upported=E2=80=99 was here
>   162 | static inline bool dax_supported(struct dax_device *dax_dev,
>       |                    ^~~~~~~~~~~~~
>   CC      lib/memregion.o
>   CC [M]  drivers/gpu/drm/drm_gem_vram_helper.o
> make[2]: *** [scripts/Makefile.build:283: drivers/dax/super.o] Error 1
> make[1]: *** [scripts/Makefile.build:500: drivers/dax] Error 2
> make[1]: *** Waiting for unfinished jobs....
>
> --- end ---
>
> That's earlier on, and then later, at the end of the (failed) build:
>
> make: *** [Makefile:1784: drivers] Error 2
>
> The full build log is at
>
> https://termbin.com/ihxj
>
> but I do not see anything else amiss. 5.9.0-rc5 built fine last week.

Reported-by: Naresh Kamboju <naresh.kamboju@linaro.org>
