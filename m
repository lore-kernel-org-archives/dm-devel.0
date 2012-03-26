From: mittals@codeaurora.org
Subject: CPU hotplug issue in dm-crypt driver
Date: Mon, 26 Mar 2012 12:28:59 -0700 (PDT)
Message-ID: <547dd161c75a98c7bcf4fb7a4d54b914.squirrel@www.codeaurora.org>
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

Hi,

We are using dm-crypt driver to encrypt Android Phone on a 2 core target.
We saw random failures (kernel panics) in scatterwalk code when we were
trying to bring secondary cpu online and offline randomly.

I looked into the dm-crypt driver(drivers/md/dm-crypt.c) and put a hack in
the kcryptd_queue_crypt function to acquire hotplug lock (using
get_online_cpus()), just before adding new work in work queue and release
this lock (using put_online_cpus) after completing work in kcryptd_crypt
function.
With this i didn't see any issue during encryption.

So my questions are -

1) Is it a know problem that there is some issue with dm-crypt driver with
cpu hotplug?

2) If yes, then can someone suggest me a cleaner way to resolve this issue?

Thanks in advance!

--Shashank

Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
