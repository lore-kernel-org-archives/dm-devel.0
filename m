From: Daniel J Walsh <dwalsh-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v3 0/7] User namespace mount updates
Date: Wed, 18 Nov 2015 13:33:26 -0500
Message-ID: <564CC476.6090400@redhat.com>
References: <1447778351-118699-1-git-send-email-seth.forshee@canonical.com>
 <20151117170556.GV22011@ZenIV.linux.org.uk>
 <20151117172551.GA108807@ubuntu-hedt>
 <20151117175506.GW22011@ZenIV.linux.org.uk> <564B79B1.3040207@gmail.com>
 <20151117193012.GX22011@ZenIV.linux.org.uk> <564B9074.5030305@gmail.com>
 <20151117210542.GY22011@ZenIV.linux.org.uk>
 <20151117220125.GF108807@ubuntu-hedt> <564C733D.7010601@gmail.com>
 <20151118143022.GC134139@ubuntu-hedt> <564C9B92.5080107@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============1877272612690908313=="
Return-path: <selinux-bounces-+05T5uksL2qpZYMLLGbcSA@public.gmane.org>
In-Reply-To: <564C9B92.5080107-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Post: <mailto:selinux-+05T5uksL2qpZYMLLGbcSA@public.gmane.org>
List-Help: <mailto:selinux-request-+05T5uksL2qpZYMLLGbcSA@public.gmane.org?subject=help>
Errors-To: selinux-bounces-+05T5uksL2qpZYMLLGbcSA@public.gmane.org
Sender: "Selinux" <selinux-bounces-+05T5uksL2qpZYMLLGbcSA@public.gmane.org>
To: Austin S Hemmelgarn <ahferroin7-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Seth Forshee <seth.forshee-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
Cc: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Serge Hallyn <serge.hallyn-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, Theodore Ts'o <tytso-3s7WtUTddSA@public.gmane.org>, dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, linux-raid-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mtd-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, Al Viro <viro-3bDd1+5oDREiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, selinux-+05T5uksL2qpZYMLLGbcSA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: dm-devel.ids

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--===============1877272612690908313==
Content-Type: multipart/alternative; boundary="=_Boundary-11444-1447871684-0001-2"

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_Boundary-11444-1447871684-0001-2
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit



On 11/18/2015 10:38 AM, Austin S Hemmelgarn wrote:
> On 2015-11-18 09:30, Seth Forshee wrote:
>> On Wed, Nov 18, 2015 at 07:46:53AM -0500, Austin S Hemmelgarn wrote:
>>> On 2015-11-17 17:01, Seth Forshee wrote:
>>>> On Tue, Nov 17, 2015 at 09:05:42PM +0000, Al Viro wrote:
>>>>> On Tue, Nov 17, 2015 at 03:39:16PM -0500, Austin S Hemmelgarn wrote:
>>>>>
>>>>>>> This is absolutely insane, no matter how much LSM snake oil you
>>>>>>> slatter on
>>>>>>> the whole thing.  All of a sudden you are exposing a huge attack
>>>>>>> surface
>>>>>>> in the place where it would hurt most and as the consolation we
>>>>>>> are offered
>>>>>>> basically "Ted is willing to fix holes when they are found".
>>>>
>>>> None of the LSM changes are intended to protect against attacks from
>>>> these sorts of attacks at all, so that's irrelevant.
>>>>
>>>> As I said before, I'm also working to find holes up front. That plus a
>>>> commitment from the maintainer seems like a good start at least. What
>>>> bar would you set for a given filesystem to be considered "safe
>>>> enough"?
>>>>
>>>>>> For the context of static image attacks, anything that's foun
>>>>>> _needs_ to be fixed regardless, and unless you can find some way to
>>>>>> actually prevent attacks on mounted filesystems that doesn't involve
>>>>>> a complete re-write of the filesystem drivers, then there's not much
>>>>>> we can do about it.  Yes, unprivileged mounts expose an attack
>>>>>> surface, but so does userspace access to the network stack, and so
>>>>>> do a lot of other features that are considered essential in a modern
>>>>>> general purpose operating system.
>>>>>
>>>>> "X is exposes an attack surface.  Y exposes a diferent attack
>>>>> surface.
>>>>> Y is considered important.  Therefore X is important enough to
>>>>> implement it"
>>>>>
>>>>> Right...
>>>>
>>>> That isn't the argument he made. I would summarize the argument as,
>>>> "Saying that X exposes an attack surface isn't by itself enough to
>>>> reject X, otherwise we wouldn't expose anything (such as example Y)."
>>> It's good to see someone understood my meaning...
>>>>
>>>> You believe that the attack surface is too large, and that's
>>>> understandable. Is it your opinion that this is a fundamental problem
>>>> for an in-kernel filesystem driver, i.e. that we can never be
>>>> confident
>>>> enough in an in-kernel filesystem parser to allow untrusted data? If
>>>> not, what would it take to establish a level of confidence that you
>>>> would be comfortable with?
>>> While I can't speak for Al's opinion on this, I would like to point
>>> out my earlier comment:
>>>> It's unfeasible from a practical standpoint to expect filesystems
>>> to > assume that stuff they write might change under them due to
>>> malicious > intent of a third party.
>>
>> So maybe the first requirement is that the user cannot modify the
>> backing store directly while the device is mounted.
>>
>>> We can't protect against everything, not without making the system
>>> completely unusable for general purpose computing.  There is always
>>> some degree of trust involved in usage of a computer, the OS has to
>>> trust that the hardware works correctly, the administrator has to
>>> trust the OS to behave correctly, and the users have to trust the
>>> administrator.  The administrator also needs to have at least some
>>> trust in the users, otherwise he shouldn't be allowing them to use
>>> the system.
>>>
>>> Perhaps we should have an option that can only be enabled on
>>> creation of the userns that would allow it to use regular kernel
>>> mounts, and without that option we default to only allowing FUSE and
>>> a couple of virtual filesystems (like /proc and devtmpfs).
>>
>> I've considered the idea of something more global like a sysctl, or a
>> per-filesystem knob in sysfs. I guess a per-container knob is another
>> option, I'm not sure what interface we use to expose it though.
>>
> The most useful way I can see of implementing this would be to have an
> option on container creation that controls whether kernel mounts are
> allowed or not (possibly have it allow any of {no mounts, only FUSE
> mounts, all mounts}), and then have a sysctl to set the default for
> containers created without this option (and possibly one to force all
> containers to ignore the option, and just use the default).
>
>
>
> _______________________________________________
> Selinux mailing list
> Selinux-+05T5uksL2qpZYMLLGbcSA@public.gmane.org
> To unsubscribe, send email to Selinux-leave-+05T5uksL2pAGbPMOrvdOA@public.gmane.org
> To get help, send an email containing "help" to Selinux-request-+05T5uksL2pAGbPMOrvdOA@public.gmane.org
From a safely/security point of view. I think you should focus on the
clear linux containers model for allowing containers on hosting
providers.  If we need "guaranteed" separation you really need to take
advantage of kvm and each container using its own kernel.  In standard
containers if a process can talk directly to the host kernel, any kernel
bug could potentially allow a break out.

--=_Boundary-11444-1447871684-0001-2
Content-Type: text/html; charset=windows-1252
Content-Transfer-Encoding: quoted-printable
X-Mime-Autoconverted: from 8bit to quoted-printable by mime827

<html>
  <head>
    <meta content=3D"text/html; charset=3Dwindows-1252"
      http-equiv=3D"Content-Type">
  </head>
  <body text=3D"#000000" bgcolor=3D"#FFFFFF">
    <br>
    <br>
    <div class=3D"moz-cite-prefix">On 11/18/2015 10:38 AM, Austin S
      Hemmelgarn wrote:<br>
    </div>
    <blockquote cite=3D"mid:564C9B92.5080107-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org" type=3D"cite">On
      2015-11-18 09:30, Seth Forshee wrote:
      <br>
      <blockquote type=3D"cite">On Wed, Nov 18, 2015 at 07:46:53AM -0500=
,
        Austin S Hemmelgarn wrote:
        <br>
        <blockquote type=3D"cite">On 2015-11-17 17:01, Seth Forshee wrot=
e:
          <br>
          <blockquote type=3D"cite">On Tue, Nov 17, 2015 at 09:05:42PM
            +0000, Al Viro wrote:
            <br>
            <blockquote type=3D"cite">On Tue, Nov 17, 2015 at 03:39:16PM
              -0500, Austin S Hemmelgarn wrote:
              <br>
              <br>
              <blockquote type=3D"cite">
                <blockquote type=3D"cite">This is absolutely insane, no
                  matter how much LSM snake oil you slatter on
                  <br>
                  the whole thing.=A0 All of a sudden you are exposing a
                  huge attack surface
                  <br>
                  in the place where it would hurt most and as the
                  consolation we are offered
                  <br>
                  basically "Ted is willing to fix holes when they are
                  found".
                  <br>
                </blockquote>
              </blockquote>
            </blockquote>
            <br>
            None of the LSM changes are intended to protect against
            attacks from
            <br>
            these sorts of attacks at all, so that's irrelevant.
            <br>
            <br>
            As I said before, I'm also working to find holes up front.
            That plus a
            <br>
            commitment from the maintainer seems like a good start at
            least. What
            <br>
            bar would you set for a given filesystem to be considered
            "safe enough"?
            <br>
            <br>
            <blockquote type=3D"cite">
              <blockquote type=3D"cite">For the context of static image
                attacks, anything that's foun
                <br>
                _needs_ to be fixed regardless, and unless you can find
                some way to
                <br>
                actually prevent attacks on mounted filesystems that
                doesn't involve
                <br>
                a complete re-write of the filesystem drivers, then
                there's not much
                <br>
                we can do about it.=A0 Yes, unprivileged mounts expose a=
n
                attack
                <br>
                surface, but so does userspace access to the network
                stack, and so
                <br>
                do a lot of other features that are considered essential
                in a modern
                <br>
                general purpose operating system.
                <br>
              </blockquote>
              <br>
              "X is exposes an attack surface.=A0 Y exposes a diferent
              attack surface.
              <br>
              Y is considered important.=A0 Therefore X is important
              enough to implement it"
              <br>
              <br>
              Right...
              <br>
            </blockquote>
            <br>
            That isn't the argument he made. I would summarize the
            argument as,
            <br>
            "Saying that X exposes an attack surface isn't by itself
            enough to
            <br>
            reject X, otherwise we wouldn't expose anything (such as
            example Y)."
            <br>
          </blockquote>
          It's good to see someone understood my meaning...
          <br>
          <blockquote type=3D"cite">
            <br>
            You believe that the attack surface is too large, and that's
            <br>
            understandable. Is it your opinion that this is a
            fundamental problem
            <br>
            for an in-kernel filesystem driver, i.e. that we can never
            be confident
            <br>
            enough in an in-kernel filesystem parser to allow untrusted
            data? If
            <br>
            not, what would it take to establish a level of confidence
            that you
            <br>
            would be comfortable with?
            <br>
          </blockquote>
          While I can't speak for Al's opinion on this, I would like to
          point
          <br>
          out my earlier comment:
          <br>
          <blockquote type=3D"cite">It's unfeasible from a practical
            standpoint to expect filesystems
            <br>
          </blockquote>
          to &gt; assume that stuff they write might change under them
          due to
          <br>
          malicious &gt; intent of a third party.
          <br>
        </blockquote>
        <br>
        So maybe the first requirement is that the user cannot modify
        the
        <br>
        backing store directly while the device is mounted.
        <br>
        <br>
        <blockquote type=3D"cite">We can't protect against everything, n=
ot
          without making the system
          <br>
          completely unusable for general purpose computing.=A0 There is
          always
          <br>
          some degree of trust involved in usage of a computer, the OS
          has to
          <br>
          trust that the hardware works correctly, the administrator has
          to
          <br>
          trust the OS to behave correctly, and the users have to trust
          the
          <br>
          administrator.=A0 The administrator also needs to have at leas=
t
          some
          <br>
          trust in the users, otherwise he shouldn't be allowing them to
          use
          <br>
          the system.
          <br>
          <br>
          Perhaps we should have an option that can only be enabled on
          <br>
          creation of the userns that would allow it to use regular
          kernel
          <br>
          mounts, and without that option we default to only allowing
          FUSE and
          <br>
          a couple of virtual filesystems (like /proc and devtmpfs).
          <br>
        </blockquote>
        <br>
        I've considered the idea of something more global like a sysctl,
        or a
        <br>
        per-filesystem knob in sysfs. I guess a per-container knob is
        another
        <br>
        option, I'm not sure what interface we use to expose it though.
        <br>
        <br>
      </blockquote>
      The most useful way I can see of implementing this would be to
      have an option on container creation that controls whether kernel
      mounts are allowed or not (possibly have it allow any of {no
      mounts, only FUSE mounts, all mounts}), and then have a sysctl to
      set the default for containers created without this option (and
      possibly one to force all containers to ignore the option, and
      just use the default).
      <br>
      <br>
      <br>
      <fieldset class=3D"mimeAttachmentHeader"></fieldset>
      <br>
      <pre wrap=3D"">_______________________________________________
Selinux mailing list
<a class=3D"moz-txt-link-abbreviated" href=3D"mailto:Selinux-+05T5uksL2pUKDJzkOSz4g@public.gmane.org=
ov">Selinux-+05T5uksL2qpZYMLLGbcSA@public.gmane.org</a>
To unsubscribe, send email to <a class=3D"moz-txt-link-abbreviated" href=
=3D"mailto:Selinux-leave-+05T5uksL2qpZYMLLGbcSA@public.gmane.org">Selinux-leave-+05T5uksL2qpZYMLLGbcSA@public.gmane.org</a>.
To get help, send an email containing "help" to <a class=3D"moz-txt-link=
-abbreviated" href=3D"mailto:Selinux-request-+05T5uksL2qpZYMLLGbcSA@public.gmane.org">Selinux-requ=
est-+05T5uksL2qpZYMLLGbcSA@public.gmane.org</a>.</pre>
    </blockquote>
    From a safely/security point of view. I think you should focus on
    the clear linux containers model for allowing containers on hosting
    providers.=A0 If we need "guaranteed" separation you really need to
    take advantage of kvm and each container using its own kernel.=A0 In
    standard containers if a process can talk directly to the host
    kernel, any kernel bug could potentially allow a break out.<br>
  </body>
</html>

--=_Boundary-11444-1447871684-0001-2--

--===============1877272612690908313==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
Selinux mailing list
Selinux-+05T5uksL2qpZYMLLGbcSA@public.gmane.org
To unsubscribe, send email to Selinux-leave-+05T5uksL2pAGbPMOrvdOA@public.gmane.org
To get help, send an email containing "help" to Selinux-request-+05T5uksL2pAGbPMOrvdOA@public.gmane.org
--===============1877272612690908313==--
