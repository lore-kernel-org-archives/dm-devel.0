From: Bernd Zeimetz <bernd@bzed.de>
Subject: Re: Clariion CX600 automatic failback support
Date: Mon, 31 Oct 2005 15:02:56 +0100
Message-ID: <200510311502.56516.bernd@bzed.de>
References: <013350FE9CC8AC4EB602045723F47222B9A2BB@xmb-rtp-215.amer.cisco.com>
	<1130767086.4071.6.camel@brilong-lnx>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1130767086.4071.6.camel@brilong-lnx>
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

> No one has automatic failback working on Clarrion storage?

failback seems to work with the latest multipath-tools, but since evms (with 
lvm-plugin..) doesn't recognize the multipath-devices anymore (it uses only 
the blank sd* devices) I never had a real chance to test it - see my mail to 
the lsit from saturday.


Bernd
