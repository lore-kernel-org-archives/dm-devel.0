From: Mike Christie <mchristi@redhat.com>
Subject: Re: Fwd: IO error on DM device
Date: Thu, 30 Mar 2006 13:44:45 -0600
Message-ID: <442C352D.8010604@redhat.com>
References: <39daa5689df1bf4a05a144891cc3563d@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <39daa5689df1bf4a05a144891cc3563d@redhat.com>
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
Cc: Ryan O'Hara <rohara@redhat.com>
List-Id: dm-devel.ids

Jonathan E Brassow wrote:
> 
>     Another observation is that we are not seeing any IO errors when the
>     same test is executed on SLES9 SP3/SP4.
> 

I think Ryan's post is correct, but I wonder why the SLES9 is not 
returning errors. Was the SLES statement referring to the scsi errors 
you see in the log like this:


     Feb  1 11:47:45 apwtest52 kernel: SCSI error : <3 0 0 1> return code
     = 0x20000

or the dm-multipath and block layer messages

Feb  1 11:48:40 apwtest52 kernel: device-mapper: dm-multipath:
     Failing path 8:32.


     Feb  1 11:48:40 apwtest52 kernel: Buffer I/O error on device dm-0,
     logical block 116940 u


or both?

Do you have the same dm-multipath settings (queue if no path, etc)? Is 
this is the qlogic qla2xxx driver? Are there qlogic guys on the list 
that would know if there are any differences between the SLES and RHEL 
drivers or are we going to have to dig in there? Are there differences 
between the SLES and RHEL dm multipath drivers? Does this occur with the 
upstream kernel?
