From: Joe Thornber <thornber@redhat.com>
Subject: Re: dm-thin vs lvm performance
Date: Fri, 27 Jan 2012 14:58:03 +0000
Message-ID: <20120127145801.GA26730@ubuntu>
References: <1326416116.56981.YahooMailNeo@web36404.mail.mud.yahoo.com>
	<20120116124158.GA4426@ubuntu>
	<1326915054.99335.YahooMailNeo@web36407.mail.mud.yahoo.com>
	<20120120170335.GA10518@ubuntu> <20120120173333.GA12920@ubuntu>
	<20120120180721.GB12920@ubuntu>
	<1327093568.21183.YahooMailNeo@web36404.mail.mud.yahoo.com>
	<20120122202429.GA27507@ubuntu>
	<1327449515.67553.YahooMailNeo@web36401.mail.mud.yahoo.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <1327449515.67553.YahooMailNeo@web36401.mail.mud.yahoo.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Jagan Reddy <gjmsreddy@yahoo.com>, device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On Tue, Jan 24, 2012 at 03:58:35PM -0800, Jagan Reddy wrote:
> Joe,
> =A0I was running more tests to get more data.

Could I trouble you to grab my test suite [1], add your machine to the
config.rb file and then:

      ./run_tests -t /RamDisk/

and see if those results are different too please?

- Joe


[1] https://github.com/jthornber/thinp-test-suite
