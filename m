From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: patch to dm.c to wakeup event waiters when map name
	changed
Date: Thu, 10 Nov 2005 23:06:58 +0000
Message-ID: <20051110230658.GK26394@agk.surrey.redhat.com>
References: <C2EEB4E538D3DC48BF57F391F422779321ADD8@srmanning.eng.emc.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <C2EEB4E538D3DC48BF57F391F422779321ADD8@srmanning.eng.emc.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: "goggin, edward" <egoggin@emc.com>
Cc: "'dm-devel@redhat.com'" <dm-devel@redhat.com>
List-Id: dm-devel.ids

On Thu, Nov 10, 2005 at 01:40:08PM -0500, goggin, edward wrote:
> Changed dm_hash_rename() to wake up any dm event waiters for
> a mapped device after changing the name of the mapped device.
 
Looks reasonable - adding to tree.

Alasdair
