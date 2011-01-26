From: Malahal Naineni <malahal@us.ibm.com>
Subject: Re: multipath: change the DEFAULT_MINIO for the request
 based multipath
Date: Tue, 25 Jan 2011 18:23:07 -0800
Message-ID: <20110126022307.GA512@us.ibm.com>
References: <91d6dae7d88296d8a1fe.1295472607@malahal>
	<4D37E513.3070506@suse.de> <20110120160726.GA23529@redhat.com>
	<4D392FBD.5080207@ce.jp.nec.com>
	<1295599627.23625.16.camel@zezette>
	<20110121141204.GE30411@redhat.com>
	<1295621193.23625.37.camel@zezette>
	<20110121173930.GB20278@us.ibm.com>
	<4D3E9020.6010009@ce.jp.nec.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <4D3E9020.6010009@ce.jp.nec.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
List-Id: dm-devel.ids

Jun'ichi Nomura [j-nomura@ce.jp.nec.com] wrote:
> >> Defaults are layered. For current minio, we have :
> >> [1] one top level default (hardcoded, superseded by config)
> >> [2] per hardware default (hardcoded, superseded by config)
> >> [3] per multipath value (none hardcoded, defined by config)
> >>
> >> You suggest multipath-tools to adapt only the top level minio default
> >> depending on dm-rq availability [1], but what of the hwtable defaults
> >> [2] ? Should we provide vendors with a way to describe a with-rq minio
> >> default *and* a without-rq minio default (a new parameter in the hwentry
> >> struct) ? If so, we should also provide a new config file keyword to
> >> override this new hwentry parameter hardcoded value ... then the
> >> reasoning cascades to the mpentry struct minio setting [3].
> >>
> >> Actually, [1] is hardly the common case : only unknown hardware resort
> >> to these defaults.
> 
> Do we really need [2]?
> 
> Currently, there seem only 3 minio values in per-hardware default:
>   - 1000 (DEFAULT_MINIO)
>   - 128
>   - 100
> 
> I think both 128 and 100 are based on that, in many systems/cases,
> max request size (max_sectors) is 512KB and BIO submission
> is done in page-size unit (4KB).
> 
> If there isn't strong reason for the current default (1000)
> (and I think there isn't), it seems we can remove [2]
> after changing the default to 128 (or 100).
> 
> > 1. Set DEFAULT_MINIO to -1
> > 2. If bio based mapping and the value is -1, set it to 1000
> >    (DEFAULT_BIO_MINIO)
> > 3. If request based mapping, set it to DEFAULT_REQUEST_MINIO.
> 
> Does it mean users can't change rr_min_io value for request-based dm?
> I suspect it is possible that someone wants to set non-default
> value to minio for request-based dm.

Your reading is correct that my proposal doesn't allow it. If we get away
with [2] above (hwatable.c based values), then we can have something
like this:

1. Remove it from hwentry structure or set it to -1
2. If rr_minio is specified in the conf file (either through default or
   device section etc), use it.
3. If not specified in the config file, use DEFAULT_BIO_MINIO or
   DEFAULT_REQUEST_MINIO based on the multipath module version.

In other words, every device out there uses DEFAULT_BIO_MINIO or
DEFAULT_REQUEST_MINIO if not specified by the administrator.
Admin can override it in /etc/multipath.conf file.

CON: No per device controller default  (aka hwtable entry value)

Thanks, Malahal.
