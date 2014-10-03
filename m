From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] dm-raid: add RAID discard support
Date: Thu, 02 Oct 2014 21:09:49 -0400
Message-ID: <yq138b6hsbm.fsf@sermon.lab.mkp.net>
References: <1411491106-23676-1-git-send-email-heinzm@redhat.com>
	<yq18ulaszpk.fsf@sermon.lab.mkp.net>
	<20140924093308.120fe616@notabene.brown>
	<yq1zjdpsqry.fsf@sermon.lab.mkp.net>
	<7C39EB56-623A-4318-A558-258ABA32FF12@redhat.com>
	<20140924142157.33475baa@notabene.brown> <5422A4C4.4020707@redhat.com>
	<20141001125625.1e0d356a@notabene.brown>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20141001125625.1e0d356a@notabene.brown> (NeilBrown's message of
	"Wed, 1 Oct 2014 12:56:25 +1000")
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: NeilBrown <neilb@suse.de>
Cc: Heinz Mauelshagen <heinzm@redhat.com>, device-mapper development <dm-devel@redhat.com>, Shaohua Li <shli@kernel.org>, "Martin K. Petersen" <martin.petersen@oracle.com>
List-Id: dm-devel.ids

>>>>> "Neil" == NeilBrown  <neilb@suse.de> writes:

Neil> I would really rather that discard_zeroes_data were only set on
Neil> devices where it was actually true.  Then it wouldn't be my
Neil> problem any more.

Yeah. It's too late for 3.18 but I'll try to get a whitelist going for
3.19.

Neil>  Here is a question: if a region has been discarded, are we
Neil>  guaranteed that reads are at least stable.  i.e. if I read twice
Neil>  will I definitely get the same value?

If discard_zeroes_data=1, then yes.

-- 
Martin K. Petersen	Oracle Linux Engineering
