From: Marcelo Matus <mmatus@dinha.acms.arizona.edu>
Subject: Re: multipath/gfs lockout under heavy write
Date: Tue, 25 Jan 2005 01:41:54 -0700
Message-ID: <41F60652.7000908@acms.arizona.edu>
References: <1106596648.13534.79.camel@laza.eunet.yu>
	<20050125040624.GB5786@redhat.com>
Reply-To: mmatus@dinha.acms.arizona.edu,
	linux clistering <linux-cluster@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-cluster-bounces@redhat.com>
In-Reply-To: <20050125040624.GB5786@redhat.com>
List-Unsubscribe: <http://www.redhat.com/mailman/listinfo/linux-cluster>,
	<mailto:linux-cluster-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/linux-cluster>
List-Post: <mailto:linux-cluster@redhat.com>
List-Help: <mailto:linux-cluster-request@redhat.com?subject=help>
List-Subscribe: <http://www.redhat.com/mailman/listinfo/linux-cluster>,
	<mailto:linux-cluster-request@redhat.com?subject=subscribe>
Sender: linux-cluster-bounces@redhat.com
Errors-To: linux-cluster-bounces@redhat.com
To: linux clistering <linux-cluster@redhat.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

David Teigland wrote:

>On Mon, Jan 24, 2005 at 08:57:28PM +0100, Lazar Obradovic wrote:
> 
>  
>
>>Since both LVs are a part of same VG (and, thus, are using the same
>>physical device seen over multipath), I'd guess the problem is somewhere
>>inside GFS, but the things that keep confusing me are: 
>>
>>- those SCSI errors that look like multipath errors
>>    
>>
>
>The SCSI errors appear to be the root problem, not GFS.  I don't know what
>multipath might have to do with it.
>
>  
>
>>- name 'diapered_dm-2' which I never saw before
>>    
>>
>
>In the past, GFS would immediately panic the machine when it saw i/o
>errors.  Now it tries to shut down the bad fs instead.  After this happens
>you should be able to unmount the offending fs, leave the cluster and
>reboot the machine cleanly.
>  
>

I have a question about your last comment. We did the following 
experiment with GFS 6.0.2:

1.- Setup a cluster using a unique GFS server and gnbd device (lock_gulm 
master
     and gnbd_export in the same node).

2.- Fence out a node manually using fence_gnbd.

then we observed two cases:

1.- If the fenced machine is not mounting the GFS/gnbd fs, but only 
importing it, then we
     can properly either reboot or restart the GFS services with no problem.

2.- If the fenced machine is mounting the GFS/gnbd fs, but with no 
process using it,
     almost everything produces a kernel panic, even just unmounting the 
unused fs.
     In fact the only thing that works, besides pushing the reset 
button, is 'reboot -f',
     which is almost the same.

So, when you say "In the past", do you refer to GFS 6.0.2 ?

>  
>
>>- fenced not fencing obviously faulty node
>>    
>>
>
>In your situation, the node is running fine wrt the cluster so there's no
>need to fence it.  GFS is just shutting down a faulty fs (doing this is
>not always very "clean" and can produce a lot of errors/warnings on the
>console.)
>
>Perhaps we could reinstate an option to have gfs panic immediately when it
>sees i/o errors instead of trying to shut down the problem fs.  In this
>case, the panicked node would be "dead" and it would be fenced.
>
>  
>
