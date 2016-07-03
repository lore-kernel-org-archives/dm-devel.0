From: Akira Hayakawa <ruby.wktk@gmail.com>
Subject: Introduce writeboost-test-suite
Date: Sun, 3 Jul 2016 22:51:52 +0900
Message-ID: <dcb100df-628c-0473-d192-60e48df30e8f@gmail.com>
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
To: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

Hi,

To test my ssd-caching module dm-writeboost (https://github.com/akiradeveloper/dm-writeboost)
I used to add tests to forked device-mapper-test-suite but I found that it's not easy to maintain
the tests because Ruby doesn't give us compile-time type checking and the code base is bit messy
because of historical reason.

So I started to develop my own test suite from scratch.

writeboost-test-suite is written in Scala. The functionality is similar to device-mapper-test-suite but
more functionalities added. It's easy to write tests safely because of static typing.

https://github.com/akiradeveloper/writeboost-test-suite

I've almost had the work done. Most of the writeboost tests are migrated and fixes the bugs in the
framework core in the course of migration.

Despite the name of the project, it's versatile. Any device-mapper targets can be tested on this framework
and actually some targets (linear, flakey and LUKS) are slightly tested, to use them in writeboost tests.

Theoretically, it's possible to test caching and thin-provisioning targets on this framework. If RH developers
feels the device-mapper-test-suite is hard to maintain and looking for alternative, very welcome.

- Akira
