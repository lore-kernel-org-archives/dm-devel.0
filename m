From: nick <xerofoify@gmail.com>
Subject: Questions about the function,
	queue_empty in dm-cache-policy-mq.c
Date: Sun, 04 Jan 2015 22:24:16 -0500
Message-ID: <54AA03E0.9020900@gmail.com>
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
To: agk@redhat.com
Cc: linux-raid@vger.kernel.org, dm-devel@redhat.com, linux-kernel@vger.kernel.org, snitzer@redhat.com
List-Id: dm-devel.ids

Greetings All,
I have a few questions about the function I stated in the message for this email.
1. What is the issues with the CPU usage for this function?
2. What hardware is this on ?
3. How scalable is this function in terms of NR_QUEUE_LEVELS and how many does it need to handle?
Nick
