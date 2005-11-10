From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: how to get mapped device name given its uuid?
Date: Thu, 10 Nov 2005 23:30:11 +0000
Message-ID: <20051110233011.GM26394@agk.surrey.redhat.com>
References: <C2EEB4E538D3DC48BF57F391F422779321ADE6@srmanning.eng.emc.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <C2EEB4E538D3DC48BF57F391F422779321ADE6@srmanning.eng.emc.com>
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

On Thu, Nov 10, 2005 at 03:33:41PM -0500, goggin, edward wrote:
> Is there a dm library interface to get the name for a dm device given its
> uuid?
 
From userspace, yes.
(libdevmapper equivalent of: dmsetup info -u <uuid>)

In kernel - no, but we could add one based on find_device().

Alasdair
-- 
agk@redhat.com
