From: Domenico Viggiani <dviggiani@tiscali.it>
Subject: RE: device mapper configurations
Date: Wed, 2 Jan 2008 15:55:57 +0100
Message-ID: <000101c84d4f$9510cb00$06000100@pitagora.it>
References: <477B9DE9.3090108@oranged.to>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <477B9DE9.3090108@oranged.to>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: 'device-mapper development' <dm-devel@redhat.com>
List-Id: dm-devel.ids

> -----Original Message-----
> From: dm-devel-bounces@redhat.com 
> [mailto:dm-devel-bounces@redhat.com] On Behalf Of Jimmy Stewpot
> Sent: Wednesday, January 02, 2008 3:21 PM
> ...
> When the system boots I get loads of errors that look like this
> 
> [  217.140126] end_request: I/O error, dev sdb, sector 0 [  
> ...
> 
> When the servers boot up. The items being reported are the 
> underlying scsi devices which we have setup above. Is it 
> normal to get these messages or do I need to explicitly place 
> the underlying devices into the blacklist?

You have an active-passive array (like my EMC Clariion) and these messages
are normal even if annoying. It's not much "professional".
With Clariion, as far as I know, the only solution is upgrading Flare to
ver. 26 that simulates active-active behaviour.

--
Domenico Viggiani
