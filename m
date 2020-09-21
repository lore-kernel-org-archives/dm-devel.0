From: Greg KH <gregkh@linuxfoundation.org>
Subject: Re: PROBLEM: 5.9.0-rc6 fails =?utf-8?Q?to_?=
 =?utf-8?Q?compile_due_to_'redefinition_of_=E2=80=98dax=5Fsupported?=
 =?utf-8?B?4oCZJw==?=
Date: Mon, 21 Sep 2020 09:32:18 +0200
Message-ID: <20200921073218.GA3142611@kroah.com>
References: <20200921010359.GO3027113@arch-chirva.localdomain>
 <CA+G9fYtCg2KjdB2oBUDJ2DKAzUxq3u8ZnMY9Et-RG9Pnrmuf9w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CA+G9fYtCg2KjdB2oBUDJ2DKAzUxq3u8ZnMY9Et-RG9Pnrmuf9w@mail.gmail.com>
To: Naresh Kamboju <naresh.kamboju@linaro.org>
Cc: Stuart Little <achirvasub@gmail.com>, Dan Williams <dan.j.williams@intel.com>, Vishal Verma <vishal.l.verma@intel.com>, Dave Jiang <dave.jiang@intel.com>, linux-nvdimm@lists.01.org, kernel list <linux-kernel@vger.kernel.org>, linux- stable <stable@vger.kernel.org>, Adrian Huang <ahuang12@lenovo.com>, Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com, Ira Weiny <ira.weiny@intel.com>, mpatocka@redhat.com, lkft-triage@lists.linaro.org, Jan Kara <jack@suse.cz>
List-Id: dm-devel.ids

On Mon, Sep 21, 2020 at 11:34:17AM +0530, Naresh Kamboju wrote:
> On Mon, 21 Sep 2020 at 06:34, Stuart Little <achirvasub@gmail.com> wrote:
> >
> > I am trying to compile for an x86_64 machine (Intel(R) Core(TM) i7-7500U CPU @ 2.70GHz). The config file I am currently using is at
> >
> > https://termbin.com/xin7
> >
> > The build for 5.9.0-rc6 fails with the following errors:
> >
> 
> arm and mips allmodconfig build breaks due to this error.

all my local builds are breaking now too with this :(

Was there a proposed patch anywhere for this?

thanks,

greg k-h
