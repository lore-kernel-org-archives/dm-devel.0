From: "David Guyon Martin" <david.guyonmartin@gmail.com>
Subject: dm-slow , a slow down dm ( dm-error alike )
Date: Tue, 10 Oct 2006 15:44:03 +0200
Message-ID: <2c53b31c0610100644o75fe3d56v261752598faebe20@mail.gmail.com>
References: <2c53b31c0610061231k8b06a4dxce2cd3a9febed86@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <2c53b31c0610061231k8b06a4dxce2cd3a9febed86@mail.gmail.com>
Content-Disposition: inline
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

Hello,

I'm looking for the same feature as Bernd
(http://www.redhat.com/archives/dm-devel/2006-February/msg00014.html),
for different purpose:
We need to slow down a disk access to be able to monitor some events,
for testing.

There is already a dm-error (faulty.c) to simulate a defective device,
why not a dm-slow for a slow device ?
I have written yet a simple unix filter to slow transfer but it can be
used only in specific cases. In the same way dm-slow would accept a
bandwidth parameter to limit read/write speed. Maybe it could also be
changed after the device setup ( slow down speed, and then resume to
full speed once finished monitoring ).

I thought that making a fork from dm-linear or dm-error would be a
good start, since I'm completly new to kernel devel.
I just wonder if my idea isn't flawed by a misunderstanding of the
general dm framework ?

Do you have any comment on this idea, or some advice ?

Thank you,
David G.M.

PS: this is a text-only repost, previous mail maybe caught by anti-spam
