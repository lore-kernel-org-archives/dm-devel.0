From: root <root@us.ibm.com>
Subject: Re: Multipath Usage Guide available at LVM wiki page
Date: Fri, 25 Jan 2008 00:44:48 -0800
Message-ID: <20080125084448.GA7600@us.ibm.com>
References: <1201199153.2634.4.camel@linuxchandra>
	<110b17190801241033t5f2cd140r65668a87357f30ad@mail.gmail.com>
	<1201213292.2634.35.camel@linuxchandra>
	<20080125021429.GC28785@us.ibm.com>
	<1201228340.2634.43.camel@linuxchandra>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <1201228340.2634.43.camel@linuxchandra>
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

Chandra Seetharaman [sekharan@us.ibm.com] wrote:
> 
> It can. I have seen it happen (in sles9 though). multipath opens the
> (sd) device and later lvm scans the same device, it fails (as there is
> already an open reference). 

That is expected but LVM should continue to scan rest of the devices
including our multipath devices. If LVM fails to scan rest of the
devices, then it should be a bug!
