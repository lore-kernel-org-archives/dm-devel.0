From: Borislav Petkov <bp@alien8.de>
Subject: Re: PROBLEM: 5.9.0-rc6 fails =?utf-8?Q?to_?=
 =?utf-8?Q?compile_due_to_'redefinition_of_=E2=80=98dax=5Fsupported?=
 =?utf-8?B?4oCZJw==?=
Date: Mon, 21 Sep 2020 10:02:58 +0200
Message-ID: <20200921080258.GA5947@zn.tnic>
References: <20200921010359.GO3027113@arch-chirva.localdomain>
 <CA+G9fYtCg2KjdB2oBUDJ2DKAzUxq3u8ZnMY9Et-RG9Pnrmuf9w@mail.gmail.com>
 <20200921073218.GA3142611@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20200921073218.GA3142611@kroah.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Naresh Kamboju <naresh.kamboju@linaro.org>, Stuart Little <achirvasub@gmail.com>, Dan Williams <dan.j.williams@intel.com>, Vishal Verma <vishal.l.verma@intel.com>, Dave Jiang <dave.jiang@intel.com>, linux-nvdimm@lists.01.org, kernel list <linux-kernel@vger.kernel.org>, linux- stable <stable@vger.kernel.org>, Adrian Huang <ahuang12@lenovo.com>, Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com, Ira Weiny <ira.weiny@intel.com>, mpatocka@redhat.com, lkft-triage@lists.linaro.org, Jan Kara <jack@suse.cz>
List-Id: dm-devel.ids

On Mon, Sep 21, 2020 at 09:32:18AM +0200, Greg KH wrote:
> all my local builds are breaking now too with this :(
> 
> Was there a proposed patch anywhere for this?

I've disabled CONFIG_BLK_DEV_PMEM which allowed me to de-select those
two:

# CONFIG_DAX is not set
# CONFIG_FS_DAX is not set

and now it at least builds.

In order to avoid such breakage in the future, I'd suggest you guys to
run randconfigs on your stuff before sending, especially if the Kconfig
ifdeffery is not a trivial one like the DAX maze.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
