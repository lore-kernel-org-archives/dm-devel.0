From: =?ISO-8859-1?Q?=22J=F3hann_B=2E_Gu=F0mundsson=22?= <johannbg@gmail.com>
Subject: Native systemd service files for multipathd
Date: Thu, 30 Jun 2011 14:10:06 +0000
Message-ID: <4E0C83BE.9020507@gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
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

Is anyone taking a look at porting the multipathd legacy sysv init 
script to native systemd unit file?

I filed 690828 on 2011-03-25 and yet to receive somekind of response on 
it and unless some action is taken then a) device-mapper-multipath will 
be blocking the Fedora 16 alpha release or b) be ripped out of @base and 
be made sure it does not get installed on the official livecd.

So please take a look at this..

Thanks
             JBG

Ps.
      You will need to cc me to your responses since I'm not subscripted 
to this list.
