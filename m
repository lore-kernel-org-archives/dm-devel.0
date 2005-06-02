From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: Can't create PVs on partitions
Date: Thu, 2 Jun 2005 17:03:45 +0100
Message-ID: <20050602160345.GH15809@agk.surrey.redhat.com>
References: <009201c561d8$49ca44b0$11051aac@pcp41116>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <009201c561d8$49ca44b0$11051aac@pcp41116>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: shahid.shaikh@patni.com
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On Thu, May 26, 2005 at 03:20:01PM +0530, shahid shaikh wrote:
>  But when i partitioned my SampleDrv devices , LVM2 is not scanning those
> partition in /etc/lvm/.cache and
 
What are the devices partitioned with?
What do the partitions look like: ls -l?

Alasdair
-- 
agk@redhat.com
