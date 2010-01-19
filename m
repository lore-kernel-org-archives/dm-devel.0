From: Pasi =?iso-8859-1?Q?K=E4rkk=E4inen?= <pasik@iki.fi>
Subject: Re: Online disk size change and Linux
Date: Tue, 19 Jan 2010 22:08:52 +0200
Message-ID: <20100119200852.GG2861@reaktio.net>
References: <2c46f67e1001190742l13ebdc1fs95aa6d545332bcc1@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <2c46f67e1001190742l13ebdc1fs95aa6d545332bcc1@mail.gmail.com>
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

On Tue, Jan 19, 2010 at 01:42:37PM -0200, Daniel Olops wrote:
>    Sorry if this is off-topic... but if anyone could help, it'd be good.
> 
>    Is Linux (more specifically Red Hat EL 5.4) able to recognize _disk_ size
>    changes online? We have some HP servers with QLogic HBAs connected to an
>    EVA 4000 Storage, with multipathing properly set up. These disks can be
>    resized online, but only after a reboot that RHEL recognizes the change.
>    I've been trying to find any information about it, but to no avail.
> 

I've done iSCSI LUN online resizing using Equallogic storage arrays.

See: http://pasik.reaktio.net/rhel5-online-iscsi-resize-test.txt

-- Pasi
