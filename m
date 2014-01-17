From: Nicolas Michel <be.nicolas.michel@gmail.com>
Subject: About WWID
Date: Fri, 17 Jan 2014 13:19:53 +0100
Message-ID: <CAO5znavrjYwyY2=bmZ0F++ePJP3+geDhUd4DVvLL8aW25xgtGg@mail.gmail.com>
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

Hello guys,

I noticed a difference with the WWID of a multipath device as reported
by the device mapper native multipath, and by the EMC propriatary tool
powermt. In the latter case it misses a leading 3 (which seems to be
an invariant prefix with the device mapper).

Exemple :

Reported by multipath -ll : 360001440000000102058055965f660d8
Reported by powermt :       60001440000000102058055965F660D8

My questions are : what means the leading 3 given by the device-mapper
and which one is the right WWID?

Thank you a lot ;)

-- 
Nicolas MICHEL
