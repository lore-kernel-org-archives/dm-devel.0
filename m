From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: Re: [PATCH] dm: Data integrity support
Date: Mon, 30 Mar 2009 02:12:48 -0400
Message-ID: <yq1skkvwnbz.fsf@sermon.lab.mkp.net>
References: <1223973159.3211181238335315043.JavaMail.root@zmail05.collab.prod.int.phx2.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1223973159.3211181238335315043.JavaMail.root@zmail05.collab.prod.int.phx2.redhat.com>
	(Mike Snitzer's message of "Sun\,
	29 Mar 2009 10\:01\:55 -0400 \(EDT\)")
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mike Snitzer <snitzer@redhat.com>, "Alasdair G. Kergon" <agk@redhat.com>
Cc: device-mapper development <dm-devel@redhat.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
List-Id: dm-devel.ids

>>>>> "Mike" == Mike Snitzer <snitzer@redhat.com> writes:

>> This patch requires a change in Jens' for-linus branch that adds a
>> GFP mask to bio_integrity_clone() and obsoletes the bio_set argument.
>> 

> I've not had the chance to track down that patch, but if you can note
> in this thread when it's hit Linus's tree, then I'll submit this one
> behind it.

Mike> Seems that change has been committed to Linus's tree with commit:
Mike> 87092698c665e0a358caf9825ae13114343027e8

The DM integrity patch depends on the following change sets:

	87092698c665e0a358caf9825ae13114343027e8

	6d2a78e783416ba99e36beb1d4395b785b34e867

Both are in Linus' tree.

-- 
Martin K. Petersen	Oracle Linux Engineering
