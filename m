From: Christophe Varoqui <christophe.varoqui@free.fr>
Subject: RE: patch to discovery.c to still get
	pathpriorityforpaths with path state of PATH_DOWN
Date: Wed, 15 Nov 2006 23:57:24 +0100
Message-ID: <1163631444.10466.146.camel@localhost.localdomain>
References: <6CCEAEDF4D06984A83F427424F47D6E4013D1552@CORPUSMX40A.corp.emc.com>
	<1163630023.10466.141.camel@localhost.localdomain>
	<1163630615.14577.4.camel@dhcp59-220.rdu.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1163630615.14577.4.camel@dhcp59-220.rdu.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: David Wysochanski <dave.wysochanski@redhat.com>
Cc: dm-devel@redhat.com, Edward Goggin <egoggin@emc.com>
List-Id: dm-devel.ids


> > Please have a careful look at the multipath/main.c:update_paths change,
> > because the (!pp->priority) that was there awfully looks like a bug (as
> > 0 is not a defined prio value).
> > 
> 
> 0 is the value you'll get though after alloc_path and before anyone
> calls pathinfo right?
> 
You're right. I forgot the memset(0...) through MALLOC().

> Your patch should be equivalent though and is clearer.
> 
Then merged.
Now that this issue is cleared, I'll push the head to korg.

Regards,
cvaroqui
