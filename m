From: Bernd Zeimetz <bernd@bzed.de>
Subject: Re: Clariion CX600 automatic failback support
Date: Sat, 5 Nov 2005 01:03:57 +0100
Message-ID: <200511050103.58170.bernd@bzed.de>
References: <C2EEB4E538D3DC48BF57F391F422779321ADAC@SRMANNING.eng.emc.com>
	<1131137721.7463.12.camel@zezette>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1131137721.7463.12.camel@zezette>
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

> I'm inclined to keep the tools patch anyway : it wastes an "int" per
> multipath but is brain-friendlier (as it avoids using mpp->nextpg to
> represent the current setting *and* the best-rated setting).
>
> Are interested parties ok with that ?

I'm ok with anything you prefer, as long as it works and it doesn't change 
again with the next kernel/tools-release ;)

Thank you,


Bernd
