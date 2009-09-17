From: David Strand <dpstrand@gmail.com>
Subject: Re: fragmented i/o with 2.6.31?
Date: Thu, 17 Sep 2009 10:32:47 -0700
Message-ID: <448b15030909171032n6c85d7ddn9dc075318376a38c@mail.gmail.com>
References: <448b15030909160834j2b127c83jab163e1860fc9aa1@mail.gmail.com>
	<448b15030909160922o84c2d6gc8ead8226dd8777a@mail.gmail.com>
	<4AB1ED1F.1010203@ct.jp.nec.com> <4AB1FDEE.5020500@ce.jp.nec.com>
	<20090917131113.GA8163@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20090917131113.GA8163@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mike Snitzer <snitzer@redhat.com>
Cc: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>, device-mapper development <dm-devel@redhat.com>, Alasdair Kergon <agk@redhat.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Jens Axboe <jens.axboe@oracle.com>
List-Id: dm-devel.ids

I have confirmed that this was the problem, and the patch fixes it, good job!
