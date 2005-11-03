From: Bernd Zeimetz <bernd@bzed.de>
Subject: Re: Clariion CX600 automatic failback support
Date: Thu, 3 Nov 2005 23:00:36 +0100
Message-ID: <200511032300.36884.bernd@bzed.de>
References: <C2EEB4E538D3DC48BF57F391F422779321ADA0@SRMANNING.eng.emc.com>
	<1131051354.4436.63.camel@brilong-lnx>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1131051354.4436.63.camel@brilong-lnx>
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
To: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

Hi,

> So it sounds like I need Red Hat to issue me a hotfix for device-mapper-
> multipath that includes the upstream patch or your patch for get
> Clariion fallback working properly.

tested on a debian sarge machine and a CX400 today, actual multipath-tools 
from git, including the patch from 
https://www.redhat.com/archives/dm-devel/2005-November/msg00028.html

Seems to work very well, especially fine that the LUNs get trespassed to their 
default owner.

Many thanks to all who made this working.


Bernd
