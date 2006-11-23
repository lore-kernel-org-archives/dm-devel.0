From: Roland Paterson-Jones <roland@rolandpj.com>
Subject: Re: Re: device mapper integrated loops - and one more
	year !
Date: Thu, 23 Nov 2006 13:15:13 +0200
Message-ID: <456582C1.3030309@rolandpj.com>
References: <1439173022@web.de>	<45636B89.7080407@redhat.com>	<456375CF.10006@rolandpj.com>	<456389C4.9000902@redhat.com>	<45640A4E.9090509@rolandpj.com>
	<4564C327.1080101@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <4564C327.1080101@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

Bryn M. Reeves wrote:

>Roland Paterson-Jones wrote:
>  
>
>>... sparse files ...
>>
>>Would you do this by using file ops to lazily fill holes on first write?
>>Is this compatible with S_SWAPFILE? For read purposes, holes can be
>>mapped to zero device, I presume.
>>    
>>
>
>That's what I figured - lazy allocation seems to be the main reason that
>sparse files are desirable.
>
>The problem with sparse files is that they make us do something that
>dm-loop is explicitly trying to avoid - calling into the filesystem at
>I/O time.
>  
>
I can live with that, as long as it's only a first-write phenomenon. 
I.e. first-write of a hole uses file-ops, then sniffs the underlying 
device mapping for subsequent ops. Although I guess this could cause the 
same OOM regime for a lot of writes on an initially sparse file (or is 
this exacerbated by loopbacks elevated priority?).

>There are two ways we can address this. The dm-loop target needs a
>non-bmap based fallback for filesystems that can't use direct mapping
>anyway (e.g. network filesystems).
>
>We can either revert to this mechanism entirely for sparse files (means
>we get many of the drawbacks of regular /dev/loopN), or try to support
>mixed extent types. That's had some thought & discussion but we don't
>have an implementation ready yet.
>  
>
I'd be very much in favour of a lazy mixed approach that converges 
towards device-only access with substantial use. Otherwise I think I'm 
back where I started.

>
>The patch currently on kernel.org uses a table format like this:
><start> <len> loop <path> <offset>
>  
>
Thanks. I'll play ;)

Roland
