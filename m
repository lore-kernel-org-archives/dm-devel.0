From: Dong Robin <robin.k.dong@gmail.com>
Subject: Question about end_clone_bio()
Date: Fri, 27 Jul 2012 13:25:44 +0800
Message-ID: <CANsebLHPw5qoizZNLuVKrS5y4JcrHPgBMysbbsZ6naFyOENfvA@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
List-Id: dm-devel.ids

Hi

There are codes in end_clone_bio():

static void end_clone_bio(struct bio *clone, int error)
{
....
        /*
         * bios are processed from the head of the list.
         * So the completing bio should always be rq->bio.
         * If it's not, something wrong is happening.
         */
        if (tio->orig->bio != bio)
                DMERR("bio completion is going in the middle of the request");
....

My question is: why the completing bio should always be rq->bio? If
the driver of a block device dispatchs all the bios belong to a
request,
how should it make sure the first completing bio is the first bio in
bio list of request ?



-- 
--
Best Regard
Robin Dong
