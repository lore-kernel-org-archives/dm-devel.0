From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH v2] dm: add topology support
Date: Wed, 10 Jun 2009 02:51:55 -0400
Message-ID: <yq1ski860ok.fsf@sermon.lab.mkp.net>
References: <1244524492-2292-1-git-send-email-snitzer@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1244524492-2292-1-git-send-email-snitzer@redhat.com> (Mike
	Snitzer's message of "Tue, 9 Jun 2009 01:14:52 -0400")
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
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
List-Id: dm-devel.ids

>>>>> "Mike" == Mike Snitzer <snitzer@redhat.com> writes:

Mike> Use blk_stack_limits() to stack block limits (including topology)
Mike> rather than duplicate the equivalent within Device Mapper.

Great!  So how are the userland bits coming along?

-- 
Martin K. Petersen	Oracle Linux Engineering
