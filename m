From: Christophe Varoqui <christophe.varoqui@free.fr>
Subject: RE: patch for handling clariion I/O to
Date: Thu, 05 Oct 2006 18:46:33 +0200
Message-ID: <1160066793.15916.35.camel@localhost.localdomain>
References: <6CCEAEDF4D06984A83F427424F47D6E4013D1418@CORPUSMX40A.corp.emc.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <6CCEAEDF4D06984A83F427424F47D6E4013D1418@CORPUSMX40A.corp.emc.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Edward Goggin <egoggin@emc.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

> > 
> > I don't see you ever reseting "allfailpaths". Isn't it a problem ?
> >
>  
> I'm counting on the MALLOC macro, (defined in memory.h and called from
> alloc_multipath) to call zalloc to zero/reset all fields of struct multipath.
> 
I meant reseting the toggle to 0 some time after a switch to 1, not at
allocation time.

I had in mind a situation of return to operational state, which seems
not possible with the current patch.

Regards,
cvaroqui
