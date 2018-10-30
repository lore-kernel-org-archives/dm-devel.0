From: Martin Wilck <mwilck@suse.de>
Subject: Re: [PATCH v3 00/22] libmultipath: checkers overhaul
Date: Tue, 30 Oct 2018 22:12:20 +0100
Message-ID: <957b33a093aeadb04123881d618af366df3ca1e7.camel@suse.de>
References: <20181030210653.29677-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20181030210653.29677-1-mwilck@suse.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

On Tue, 2018-10-30 at 22:06 +0100, Martin Wilck wrote:
> 
> First, there's a block of patches to get rid of the "message"
> char array in struct checker, replacing it with an integer.
> This topic had been touched in recent discussion between Ben
> and myself.

Note that these patches (03-11) depend on each other;
there will be compilation errors if they're not all applied.
When you merge, you may want to collapse them into one big
patch, but for review purposes I thought the split format
was preferrable.

Martin
