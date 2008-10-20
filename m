From: Milan Broz <mbroz@redhat.com>
Subject: Re: Calltrace in dm-snapshot in 2.6.27 kernel
Date: Mon, 20 Oct 2008 10:43:04 +0200
Message-ID: <48FC4498.5070706@redhat.com>
References: <48FC23DE.5040000@poczta.onet.pl>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <48FC23DE.5040000@poczta.onet.pl>
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

aluno3@poczta.onet.pl wrote:
> I've got this calltrace from our QA team. They say that they mad few
> snapshots, run several programs like bacula or rsync and that calltrace
> is appearing about 1 hour after starting those programs.

Hi,
if it is reproducible, please can you try if this patch helps?
http://www.kernel.org/pub/linux/kernel/people/agk/patches/2.6/editing/dm-snapshot-fix-primary_pe-race.patch

Probably the same problem reported here
http://bugzilla.kernel.org/show_bug.cgi?id=11636

(Added Mikulas to CC)

Milan
--
mbroz@redhat.com
