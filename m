From: Christophe Varoqui <christophe.varoqui@free.fr>
Subject: Re: LVM Multipathing
Date: Sun, 13 Feb 2005 12:53:00 +0100
Message-ID: <420F3F9C.3050809@free.fr>
References: <000101c511bf$41a22be0$11051aac@pcp41116>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
In-Reply-To: <000101c511bf$41a22be0$11051aac@pcp41116>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: shahid.shaikh@patni.com, device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

I was thinking about that part :

---


      3. LVM2 doesn't see my multipathed devices as PV, what's up ?

By default, lvm2 does not consider device-mapper block devices (such as 
a dm-crypt device) for use as physical volumes.

In order to use a dm-crypt device as an lvm2 pv, add this line to the 
devices block in /etc/lvm/lvm.conf:

types = [ "device-mapper", 16 ]

If /etc/lvm/lvm.conf does not exist, you can create one based on your 
current/default config like so:

lvm dumpconfig > /etc/lvm/lvm.conf

(tip from Christophe Saout)
---

... then again,

"you need to exclude the paths from the scaning"


regards,
cvaroqui

shahid shaikh wrote:

>Hello,
>
>I seen FAQ. Part relevant to me from FAQ (copied below) consist semething
>related to files /etc/mkinitrd/modules and
>/etc/mkinitrd/scripts.
>But these files are not peresnt at the given location on my system.
>I have installed udev-021-36.32 and multipath-tools-0.2.1 ( one which come
>bundled with SLES9).
>Please let me know why they are not present over. is there something still
>missing?
>Or i need install something else ( obviously excluding OS)?
>  
>


--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel
