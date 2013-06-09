From: =?iso-8859-1?Q?Beno=EEt?= Canet <benoit.canet@irqsave.net>
Subject: dm-thin and shared storage failover
Date: Sun, 9 Jun 2013 15:32:54 +0200
Message-ID: <20130609133253.GB4336@irqsave.net>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
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


Hello,

I am trying to come with an efficient dm-thin HA setup and there is very few
litterature on the subject since dm-thin is so new.

So I will ask my questions to this list so the responses could serve as lat=
er
reference for the interweb.

I clearly understood that dm-thin is not clustered and should not be used a=
t the
same time on two nodes.
So I am thinking of an active/passive setup with shared SAS storage.

I have the following setup in mind.

A SAS storage bay would be shared between two active/passive nodes.

dm-thin and lvm modules would be loaded on the active node and not on the
passive node.

On an active node crash or power failure the passive node would load lvm mo=
dules
and the dm-thin module taking control of the SAS enclosure.

I can make sure that the upper layer is redundant between the node so no IO=
s is
lost during failover. This layer would open the dm-thin volume on the passi=
ve
node after takeover happened an redo IOs lost in the crash.

My questions boils down to:

How dm-thin cope with crash or powerfailure ?
What is the level of atomicity in dm-thin IOs ?
Are operations done via a journal or soft updates ?

Generally do you think this kind of setup would work ?

Best regards

Beno=EEt Canet
