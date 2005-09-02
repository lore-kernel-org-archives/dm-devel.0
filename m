From: christophe varoqui <christophe.varoqui@free.fr>
Subject: Re: FW: How to avoid lots of read ios to passive paths
	of active-pass ive storage devices?
Date: Fri, 02 Sep 2005 23:17:11 +0200
Message-ID: <1125695831.6217.12.camel@zezette>
References: <C2EEB4E538D3DC48BF57F391F422779321AC40@SRMANNING.eng.emc.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <C2EEB4E538D3DC48BF57F391F422779321AC40@SRMANNING.eng.emc.com>
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

What if we claim exclusively these passive paths from multipathd ?

Regards,

On ven, 2005-09-02 at 10:25 -0400, goggin, edward wrote:
> Reposting since it didn't get much response initially and the issue came up
> again
> in yesterday's multipath conference call.
> 
> > ______________________________________________ 
> > From: 	goggin, edward  
> > Sent:	Friday, July 08, 2005 12:21 AM
> > To:	'dm-devel@redhat.com'
> > Subject:	How to avoid lots of read ios to passive paths of
> > active-passive storage devices?
> > 
> > How sould device scanning utilities like blkid, pvscan,
> > vgscan, and lvscan (others?) be made to avoid issuing
> > a significant number of read ios to passive paths of
> > active-passive storage devices?
> > 
> > Possibly they could be changed to use device specific
> > command interfaces like SCSI pass through ioctls to
> > read the native device paths in order to avoid sending
> > lots of ios down the passive paths to active-passive
> > storage devices?
> > 
> > This way they could parse the sense key, ASC, and ASCQ
> > returned via the SG_IO interface, see values like
> > "Not Ready, Manual Intervention Required" and avoid
> > sending subsequent reads to the same path.
> > 
> > Or should they be changed to scan the multipath devices
> > if they exist instead of the path specific devices?
> > 
> > While this isn't an issue now, it could become one later
> > when/if linux hosts are configured with hundreds/thousands
> > of passive paths.
> > 
> 
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
-- 
christophe varoqui <christophe.varoqui@free.fr>
