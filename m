From: Adam Hamsik <haaaad@gmail.com>
Subject: Re: LVM Snapshot Feature
Date: Fri, 1 Aug 2008 17:52:04 +0200
Message-ID: <1746B17C-CC23-40D7-A993-FC32CAA5BF24@gmail.com>
References: <4DE0C34D8B0DA64C9585DC45C36EA03BAB0788@dewdfe1g.wdf.sap.corp>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0 (Apple Message framework v926)
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <4DE0C34D8B0DA64C9585DC45C36EA03BAB0788@dewdfe1g.wdf.sap.corp>
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


On Aug,Friday 1 2008, at 9:35 AM, Bombardier, Pascal wrote:

> Hi,
>
> In your opinion, does it make sense to be able to create non- 
> persistent
> snapshots ?
> In the case of a filesystem backup, a non-persistent snapshot would  
> be a
> snapshot that we agree to lose in case of failure or reboot. If  
> anything
> happens, a server administrator would have to recreate a new snapshot
> and then restart the backup.
> In this case, I think metadata could be stored in memory instead of on
> disk, which should improve LVM snapshot performance.
>
> Is this theory wrong, and is this something which can be implemented
> easily in the current LVM code ?
>

AFAIK non-persistent snapshots are already implemented see
DM_PERSISTENT_DEV_FLAG ? I haven't look at linux kernel code how is
it done but when I solve my lvcreate -s bug on NetBSD non-persistent
snapshots are next :).

Regards

Adam.
