From: Ondrej Palkovsky <ondrap@penguin.cz>
Subject: dm-raid1 - error handling?
Date: Tue, 04 Dec 2007 17:53:06 +0100
Message-ID: <475585F2.2040509@penguin.cz>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
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

I have been browsing through source code of dm-raid1.c (kernel 2.6.23.1) 
and this seems to me weird.
Function write_callback in dm-raid1.c - what is it supposed to do? 
First, the if (error) block seems
like just one big NOP, second it looks like any error slips undetected.  
Am I correct or is there some logic I am not aware of?

Ondrej

{
.. declarations etc...
    if (error) {
        /*
         * only error the io if all mirrors failed.
         * FIXME: bogus
         */
        uptodate = 0;
        for (i = 0; i < ms->nr_mirrors; i++)
            if (!test_bit(i, &error)) {
                uptodate = 1;
                break;
            }
    }
    bio_endio(bio, bio->bi_size, 0);
} - end of function
