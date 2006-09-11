From: Luca Berra <bluca@comedia.it>
Subject: Re: lvresize fails with "reload ioctl failed: Invalid
	argument"
Date: Mon, 11 Sep 2006 16:19:16 +0200
Message-ID: <20060911141916.GC13522@percy.comedia.it>
References: <ee20kk$s7u$1@sea.gmane.org>
	<20060910221427.GF13859@agk.surrey.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20060910221427.GF13859@agk.surrey.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
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

On Sun, Sep 10, 2006 at 11:14:27PM +0100, Alasdair G Kergon wrote:
>On Sun, Sep 10, 2006 at 11:38:27PM +0200, Laurent Riffard wrote:
>>  device-mapper: reload ioctl failed: Invalid argument
>
>>  LVM version:     2.02.06 (2006-05-12)
>>  Library version: 1.02.09 (2006-08-15)
>>  Driver version:  4.8.0
>> Linux version 2.6.18-rc6-mm1 (laurent@calimero.antadix) (gcc version 4.1.1 
>> 20060724 (prerelease) (4.1.1-3mdk)) #145 Sun Sep 10 20:48:49 CEST 2006
> 
>
>> Is it a known problem ? 
>
>Not sure, but try updating lvm2 version to the same date as the
>library version (at least 2.02.08 15th August).
>
Laurent, can you please try the packages from:
http://kenobi.mandriva.com/~bluca/

10x
L.

-- 
Luca Berra -- bluca@comedia.it
        Communication Media & Services S.r.l.
 /"\
 \ /     ASCII RIBBON CAMPAIGN
  X        AGAINST HTML MAIL
 / \
