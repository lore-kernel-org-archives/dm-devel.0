From: Brassow Jonathan <jbrassow@redhat.com>
Subject: Re: noob usage question
Date: Fri, 9 Aug 2013 17:22:16 -0500
Message-ID: <34D36EB6-401C-4825-8D1E-B277EDD39ACF@redhat.com>
References: <CAH1aXXbG68BSLqvZeoANUkVykcBnNnTfnPqYbCVke89kBU_WTQ@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0 (Apple Message framework v1085)
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <CAH1aXXbG68BSLqvZeoANUkVykcBnNnTfnPqYbCVke89kBU_WTQ@mail.gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids


On Aug 9, 2013, at 4:01 PM, John Strange wrote:

> When I create a linear target, I can't create partitions or format the mapped drive.  I get an invalid parameter argument for an ioctl.  I'm obviously doing something stupid.  What do I need to do to create partitions, format, mount a dm-n?

You don't want to create partitions, do you?

Just create an mapping and use it.  If you need another, create another.  Need to remove one, just remove it.

Also, I'm assuming you want to use device-mapper.  If you want persistent devices (ones that stick around after a reboot), you may wish to use LVM.

 brassow
