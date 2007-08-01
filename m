From: Bernd Zeimetz <bernd@bzed.de>
Subject: Re: RH 4 and HSG80
Date: Wed, 01 Aug 2007 22:20:53 +0200
Message-ID: <46B0EB25.90103@bzed.de>
References: <OFD9DA3C9D.6E99EABB-ONC125732A.005472D4-C125732A.0055D34C@de.ibm.com>
	<46B0BEB9.4060303@interactivebrokers.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <46B0BEB9.4060303@interactivebrokers.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
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

Eric Ritchie wrote:
> Thanks for the help. Unfortunately, I don't have /sbin/mpath_prio_hp_sw.
> I have other mpath_prio files but not the hp one. I guess that means I
> need a newer version of multipath-tools. How can I upgrade to the latest
> version?

you'll have to build it from git.
Also you need to build the hp_sw module for your kernel, patches which
at least build with 2.6.21 and .22 were posted on this list some days ago.


Cheers,

Bernd

-- 
Bernd Zeimetz
<bernd@bzed.de>                         <http://bzed.de/>
