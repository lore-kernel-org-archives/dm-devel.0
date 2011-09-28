From: Jojy Varghese <jojy.varghese@gmail.com>
Subject: error injection
Date: Wed, 28 Sep 2011 12:32:07 -0700
Message-ID: <CAJD3hpVdze+RBjUbeCPuB1wEy4c4q=uFpjGVXbTgo1LoV9oEFQ@mail.gmail.com>
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
  I am trying to dynamically add error injection to our virtual
disk(LVM) for testing+ debugging purpose. I saw "faulty" personality
module in the kernel and was wondering if there was any documentation
on its usage. I am not looking to set up a RAID but a simple mapped
device. So the basic use case is that I need to be able to dynamically
add/remove error sectors and also be able to have granular error
configuration like read error, read+write error etc.

thanks in advance
Jojy
