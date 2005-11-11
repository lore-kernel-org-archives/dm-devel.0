From: Bernd Zeimetz <bernd@bzed.de>
Subject: Re: Automatic failback with multipath
Date: Fri, 11 Nov 2005 18:49:34 +0100
Message-ID: <200511111849.35565.bernd@bzed.de>
References: <200511111721.jABHLQto010050@mh0.sv.mailhost.seagate.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <200511111721.jABHLQto010050@mh0.sv.mailhost.seagate.com>
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

> Any help would be appreciated.

You should definitely use actual multipath-tools, best is to get them from git 
and compile them. If you have trouble with that send me the output of your 
compiler and I'll try to figure out what's wrong. Also check
http://christophe.varoqui.free.fr/wiki/wakka.php?wiki=TestedEnvironments
- at the bottom of the page is my short summary about running an EMC CX with 
multipath-tools - at least what I've figured out. There's also a link to a 
longer thread on the dm-devel list, you probably want to read it.


Bye,

Bernd
