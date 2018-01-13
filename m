From: Christophe Varoqui <christophe.varoqui@opensvc.com>
Subject: Re: [PATCH] multipath-tools: refresh kernel-doc from
	kernel sources
Date: Sat, 13 Jan 2018 09:55:24 +0100
Message-ID: <CABr-GncahOyS5r5Y-FP5ZKDXqLVV4=yb5VkbAeiTHr5OtW83Lg@mail.gmail.com>
References: <20171117165425.5378-1-xose.vazquez@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============8012034701324078916=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20171117165425.5378-1-xose.vazquez@gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Xose Vazquez Perez <xose.vazquez@gmail.com>
Cc: Gris Ge <fge@redhat.com>, device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

--===============8012034701324078916==
Content-Type: multipart/alternative; boundary="001a114aac8cbd3c1a0562a48ad9"

--001a114aac8cbd3c1a0562a48ad9
Content-Type: text/plain; charset="UTF-8"

Applied.
Thanks.

On Fri, Nov 17, 2017 at 5:54 PM, Xose Vazquez Perez <xose.vazquez@gmail.com>
wrote:

> Cc: Gris Ge <fge@redhat.com>
> Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
> Cc: device-mapper development <dm-devel@redhat.com>
> Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
> ---
>  libdmmp/docs/kernel-doc | 164 ++++++++++++++++++++++++++++++
> ++++--------------
>  1 file changed, 118 insertions(+), 46 deletions(-)
>
> diff --git a/libdmmp/docs/kernel-doc b/libdmmp/docs/kernel-doc
> index 8f5b546..7bd52b8 100644
> --- a/libdmmp/docs/kernel-doc
> +++ b/libdmmp/docs/kernel-doc
> @@ -1,5 +1,6 @@
> -#!/usr/bin/perl -w
> +#!/usr/bin/env perl
>
> +use warnings;
>  use strict;
>
>  ## Copyright (c) 1998 Michael Zucchi, All Rights Reserved        ##
> @@ -199,29 +200,36 @@ EOF
>  # 'funcname()' - function
>  # '$ENVVAR' - environmental variable
>  # '&struct_name' - name of a structure (up to two words including
> 'struct')
> +# '&struct_name.member' - name of a structure member
>  # '@parameter' - name of a parameter
>  # '%CONST' - name of a constant.
> +# '``LITERAL``' - literal string without any spaces on it.
>
>  ## init lots of data
>
> -
>  my $errors = 0;
>  my $warnings = 0;
>  my $anon_struct_union = 0;
>
>  # match expressions used to find embedded type information
> -my $type_constant = '\%([-_\w]+)';
> +my $type_constant = '\b``([^\`]+)``\b';
> +my $type_constant2 = '\%([-_\w]+)';
>  my $type_func = '(\w+)\(\)';
>  my $type_param = '\@(\w+(\.\.\.)?)';
>  my $type_fp_param = '\@(\w+)\(\)';  # Special RST handling for func ptr
> params
> -my $type_struct = '\&((struct\s*)*[_\w]+)';
> -my $type_struct_xml = '\\&amp;((struct\s*)*[_\w]+)';
>  my $type_env = '(\$\w+)';
> -my $type_enum_full = '\&(enum)\s*([_\w]+)';
> -my $type_struct_full = '\&(struct)\s*([_\w]+)';
> -my $type_typedef_full = '\&(typedef)\s*([_\w]+)';
> -my $type_union_full = '\&(union)\s*([_\w]+)';
> -my $type_member = '\&([_\w]+)((\.|->)[_\w]+)';
> +my $type_enum = '\&(enum\s*([_\w]+))';
> +my $type_struct = '\&(struct\s*([_\w]+))';
> +my $type_typedef = '\&(typedef\s*([_\w]+))';
> +my $type_union = '\&(union\s*([_\w]+))';
> +my $type_member = '\&([_\w]+)(\.|->)([_\w]+)';
> +my $type_fallback = '\&([_\w]+)';
> +my $type_enum_xml = '\&amp;(enum\s*([_\w]+))';
> +my $type_struct_xml = '\&amp;(struct\s*([_\w]+))';
> +my $type_typedef_xml = '\&amp;(typedef\s*([_\w]+))';
> +my $type_union_xml = '\&amp;(union\s*([_\w]+))';
> +my $type_member_xml = '\&amp;([_\w]+)(\.|-\&gt;)([_\w]+)';
> +my $type_fallback_xml = '\&amp([_\w]+)';
>  my $type_member_func = $type_member . '\(\)';
>
>  # Output conversion substitutions.
> @@ -230,10 +238,16 @@ my $type_member_func = $type_member . '\(\)';
>  # these work fairly well
>  my @highlights_html = (
>                         [$type_constant, "<i>\$1</i>"],
> +                       [$type_constant2, "<i>\$1</i>"],
>                         [$type_func, "<b>\$1</b>"],
> +                       [$type_enum_xml, "<i>\$1</i>"],
>                         [$type_struct_xml, "<i>\$1</i>"],
> +                       [$type_typedef_xml, "<i>\$1</i>"],
> +                       [$type_union_xml, "<i>\$1</i>"],
>                         [$type_env, "<b><i>\$1</i></b>"],
> -                       [$type_param, "<tt><b>\$1</b></tt>"]
> +                       [$type_param, "<tt><b>\$1</b></tt>"],
> +                       [$type_member_xml, "<tt><i>\$1</i>\$2\$3</tt>"],
> +                       [$type_fallback_xml, "<i>\$1</i>"]
>                        );
>  my $local_lt = "\\\\\\\\lt:";
>  my $local_gt = "\\\\\\\\gt:";
> @@ -242,10 +256,16 @@ my $blankline_html = $local_lt . "p" . $local_gt; #
> was "<p>"
>  # html version 5
>  my @highlights_html5 = (
>                          [$type_constant, "<span
> class=\"const\">\$1</span>"],
> +                        [$type_constant2, "<span
> class=\"const\">\$1</span>"],
>                          [$type_func, "<span class=\"func\">\$1</span>"],
> +                        [$type_enum_xml, "<span
> class=\"enum\">\$1</span>"],
>                          [$type_struct_xml, "<span
> class=\"struct\">\$1</span>"],
> +                        [$type_typedef_xml, "<span
> class=\"typedef\">\$1</span>"],
> +                        [$type_union_xml, "<span
> class=\"union\">\$1</span>"],
>                          [$type_env, "<span class=\"env\">\$1</span>"],
> -                        [$type_param, "<span class=\"param\">\$1</span>]"]
> +                        [$type_param, "<span
> class=\"param\">\$1</span>]"],
> +                        [$type_member_xml, "<span class=\"literal\"><span
> class=\"struct\">\$1</span>\$2<span class=\"member\">\$3</span></span>"],
> +                        [$type_fallback_xml, "<span
> class=\"struct\">\$1</span>"]
>                        );
>  my $blankline_html5 = $local_lt . "br /" . $local_gt;
>
> @@ -253,55 +273,80 @@ my $blankline_html5 = $local_lt . "br /" . $local_gt;
>  my @highlights_xml = (
>                        ["([^=])\\\"([^\\\"<]+)\\\"",
> "\$1<quote>\$2</quote>"],
>                        [$type_constant, "<constant>\$1</constant>"],
> +                      [$type_constant2, "<constant>\$1</constant>"],
> +                      [$type_enum_xml, "<type>\$1</type>"],
>                        [$type_struct_xml, "<structname>\$1</structname>"],
> +                      [$type_typedef_xml, "<type>\$1</type>"],
> +                      [$type_union_xml, "<structname>\$1</structname>"],
>                        [$type_param, "<parameter>\$1</parameter>"],
>                        [$type_func, "<function>\$1</function>"],
> -                      [$type_env, "<envar>\$1</envar>"]
> +                      [$type_env, "<envar>\$1</envar>"],
> +                      [$type_member_xml, "<literal><structname>\$1</
> structname>\$2<structfield>\$3</structfield></literal>"],
> +                      [$type_fallback_xml, "<structname>\$1</structname>"
> ]
>                      );
>  my $blankline_xml = $local_lt . "/para" . $local_gt . $local_lt . "para"
> . $local_gt . "\n";
>
>  # gnome, docbook format
>  my @highlights_gnome = (
>                          [$type_constant, "<replaceable
> class=\"option\">\$1</replaceable>"],
> +                        [$type_constant2, "<replaceable
> class=\"option\">\$1</replaceable>"],
>                          [$type_func, "<function>\$1</function>"],
> +                        [$type_enum, "<type>\$1</type>"],
>                          [$type_struct, "<structname>\$1</structname>"],
> +                        [$type_typedef, "<type>\$1</type>"],
> +                        [$type_union, "<structname>\$1</structname>"],
>                          [$type_env, "<envar>\$1</envar>"],
> -                        [$type_param, "<parameter>\$1</parameter>" ]
> +                        [$type_param, "<parameter>\$1</parameter>" ],
> +                        [$type_member, "<literal><structname>\$1</
> structname>\$2<structfield>\$3</structfield></literal>"],
> +                        [$type_fallback, "<structname>\$1</structname>"]
>                        );
>  my $blankline_gnome = "</para><para>\n";
>
>  # these are pretty rough
>  my @highlights_man = (
>                        [$type_constant, "\$1"],
> +                      [$type_constant2, "\$1"],
>                        [$type_func, "\\\\fB\$1\\\\fP"],
> +                      [$type_enum, "\\\\fI\$1\\\\fP"],
>                        [$type_struct, "\\\\fI\$1\\\\fP"],
> -                      [$type_param, "\\\\fI\$1\\\\fP"]
> +                      [$type_typedef, "\\\\fI\$1\\\\fP"],
> +                      [$type_union, "\\\\fI\$1\\\\fP"],
> +                      [$type_param, "\\\\fI\$1\\\\fP"],
> +                      [$type_member, "\\\\fI\$1\$2\$3\\\\fP"],
> +                      [$type_fallback, "\\\\fI\$1\\\\fP"]
>                      );
>  my $blankline_man = "";
>
>  # text-mode
>  my @highlights_text = (
>                         [$type_constant, "\$1"],
> +                       [$type_constant2, "\$1"],
>                         [$type_func, "\$1"],
> +                       [$type_enum, "\$1"],
>                         [$type_struct, "\$1"],
> -                       [$type_param, "\$1"]
> +                       [$type_typedef, "\$1"],
> +                       [$type_union, "\$1"],
> +                       [$type_param, "\$1"],
> +                       [$type_member, "\$1\$2\$3"],
> +                       [$type_fallback, "\$1"]
>                       );
>  my $blankline_text = "";
>
>  # rst-mode
>  my @highlights_rst = (
>                         [$type_constant, "``\$1``"],
> +                       [$type_constant2, "``\$1``"],
>                         # Note: need to escape () to avoid func matching
> later
> -                       [$type_member_func, "\\:c\\:type\\:`\$1\$2\\\\(\\\\)
> <\$1>`"],
> -                       [$type_member, "\\:c\\:type\\:`\$1\$2 <\$1>`"],
> +                       [$type_member_func, "\\:c\\:type\\:`\$1\$2\$3\\\\(\\\\)
> <\$1>`"],
> +                       [$type_member, "\\:c\\:type\\:`\$1\$2\$3 <\$1>`"],
>                        [$type_fp_param, "**\$1\\\\(\\\\)**"],
>                         [$type_func, "\\:c\\:func\\:`\$1()`"],
> -                       [$type_struct_full, "\\:c\\:type\\:`\$1 \$2
> <\$2>`"],
> -                       [$type_enum_full, "\\:c\\:type\\:`\$1 \$2 <\$2>`"],
> -                       [$type_typedef_full, "\\:c\\:type\\:`\$1 \$2
> <\$2>`"],
> -                       [$type_union_full, "\\:c\\:type\\:`\$1 \$2
> <\$2>`"],
> +                       [$type_enum, "\\:c\\:type\\:`\$1 <\$2>`"],
> +                       [$type_struct, "\\:c\\:type\\:`\$1 <\$2>`"],
> +                       [$type_typedef, "\\:c\\:type\\:`\$1 <\$2>`"],
> +                       [$type_union, "\\:c\\:type\\:`\$1 <\$2>`"],
>                         # in rst this can refer to any type
> -                       [$type_struct, "\\:c\\:type\\:`\$1`"],
> +                       [$type_fallback, "\\:c\\:type\\:`\$1`"],
>                         [$type_param, "**\$1**"]
>                       );
>  my $blankline_rst = "\n";
> @@ -309,9 +354,15 @@ my $blankline_rst = "\n";
>  # list mode
>  my @highlights_list = (
>                         [$type_constant, "\$1"],
> +                       [$type_constant2, "\$1"],
>                         [$type_func, "\$1"],
> +                       [$type_enum, "\$1"],
>                         [$type_struct, "\$1"],
> -                       [$type_param, "\$1"]
> +                       [$type_typedef, "\$1"],
> +                       [$type_union, "\$1"],
> +                       [$type_param, "\$1"],
> +                       [$type_member, "\$1"],
> +                       [$type_fallback, "\$1"]
>                       );
>  my $blankline_list = "";
>
> @@ -414,7 +465,7 @@ my $doc_com = '\s*\*\s*';
>  my $doc_com_body = '\s*\* ?';
>  my $doc_decl = $doc_com . '(\w+)';
>  # @params and a strictly limited set of supported section names
> -my $doc_sect = $doc_com .
> +my $doc_sect = $doc_com .
>      '\s*(\@[.\w]+|\@\.\.\.|description|context|returns?|
> notes?|examples?)\s*:(.*)';
>  my $doc_content = $doc_com_body . '(.*)';
>  my $doc_block = $doc_com . 'DOC:\s*(.*)?';
> @@ -1131,8 +1182,9 @@ sub output_function_xml(%) {
>         foreach $parameter (@{$args{'parameterlist'}}) {
>             my $parameter_name = $parameter;
>             $parameter_name =~ s/\[.*//;
> +           $type = $args{'parametertypes'}{$parameter};
>
> -           print "  <varlistentry>\n   <term><parameter>$parameter</
> parameter></term>\n";
> +           print "  <varlistentry>\n   <term><parameter>$type
> $parameter</parameter></term>\n";
>             print "   <listitem>\n    <para>\n";
>             $lineprefix="     ";
>             output_highlight($args{'parameterdescs'}{$parameter_name});
> @@ -1223,8 +1275,9 @@ sub output_struct_xml(%) {
>
>        defined($args{'parameterdescs'}{$parameter_name}) || next;
>        ($args{'parameterdescs'}{$parameter_name} ne $undescribed) || next;
> +      $type = $args{'parametertypes'}{$parameter};
>        print "    <varlistentry>";
> -      print "      <term>$parameter</term>\n";
> +      print "      <term><literal>$type $parameter</literal></term>\n";
>        print "      <listitem><para>\n";
>        output_highlight($args{'parameterdescs'}{$parameter_name});
>        print "      </para></listitem>\n";
> @@ -1883,7 +1936,7 @@ sub output_function_rst(%) {
>      $lineprefix = "  ";
>      foreach $parameter (@{$args{'parameterlist'}}) {
>         my $parameter_name = $parameter;
> -       #$parameter_name =~ s/\[.*//;
> +       $parameter_name =~ s/\[.*//;
>         $type = $args{'parametertypes'}{$parameter};
>
>         if ($type ne "") {
> @@ -2115,7 +2168,7 @@ sub dump_struct($$) {
>      my $nested;
>
>      if ($x =~ /(struct|union)\s+(\w+)\s*{(.*)}/) {
> -       #my $decl_type = $1;
> +       my $decl_type = $1;
>         $declaration_name = $2;
>         my $members = $3;
>
> @@ -2129,17 +2182,17 @@ sub dump_struct($$) {
>         # strip comments:
>         $members =~ s/\/\*.*?\*\///gos;
>         $nested =~ s/\/\*.*?\*\///gos;
> -       # strip kmemcheck_bitfield_{begin,end}.*;
> -       $members =~ s/kmemcheck_bitfield_.*?;//gos;
>         # strip attributes
>         $members =~ s/__attribute__\s*\(\([a-z,_\*\s\(\)]*\)\)//i;
>         $members =~ s/__aligned\s*\([^;]*\)//gos;
>         $members =~ s/\s*CRYPTO_MINALIGN_ATTR//gos;
>         # replace DECLARE_BITMAP
>         $members =~ s/DECLARE_BITMAP\s*\(([^,)]+), ([^,)]+)\)/unsigned
> long $1\[BITS_TO_LONGS($2)\]/gos;
> +       # replace DECLARE_HASHTABLE
> +       $members =~ s/DECLARE_HASHTABLE\s*\(([^,)]+), ([^,)]+)\)/unsigned
> long $1\[1 << (($2) - 1)\]/gos;
>
>         create_parameterlist($members, ';', $file);
> -       check_sections($file, $declaration_name, "struct", $sectcheck,
> $struct_actual, $nested);
> +       check_sections($file, $declaration_name, $decl_type, $sectcheck,
> $struct_actual, $nested);
>
>         output_declaration($declaration_name,
>                            'struct',
> @@ -2171,6 +2224,9 @@ sub dump_enum($$) {
>      if ($x =~ /enum\s+(\w+)\s*{(.*)}/) {
>         $declaration_name = $1;
>         my $members = $2;
> +       my %_members;
> +
> +       $members =~ s/\s+$//;
>
>         foreach my $arg (split ',', $members) {
>             $arg =~ s/^\s*(\w+).*/$1/;
> @@ -2180,9 +2236,16 @@ sub dump_enum($$) {
>                 print STDERR "${file}:$.: warning: Enum value '$arg' ".
>                     "not described in enum '$declaration_name'\n";
>             }
> -
> +           $_members{$arg} = 1;
>         }
>
> +       while (my ($k, $v) = each %parameterdescs) {
> +           if (!exists($_members{$k})) {
> +            print STDERR "${file}:$.: warning: Excess enum value " .
> +                         "'$k' description in '$declaration_name'\n";
> +           }
> +        }
> +
>         output_declaration($declaration_name,
>                            'enum',
>                            {'enum' => $declaration_name,
> @@ -2350,8 +2413,7 @@ sub push_parameter($$$) {
>         }
>
>         $anon_struct_union = 0;
> -       my $param_name = $param;
> -       $param_name =~ s/\[.*//;
> +       $param =~ s/[\[\)].*//;
>
>         if ($type eq "" && $param =~ /\.\.\.$/)
>         {
> @@ -2382,9 +2444,9 @@ sub push_parameter($$$) {
>         # but inline preprocessor statements);
>         # also ignore unnamed structs/unions;
>         if (!$anon_struct_union) {
> -       if (!defined $parameterdescs{$param_name} && $param_name !~ /^#/) {
> +       if (!defined $parameterdescs{$param} && $param !~ /^#/) {
>
> -           $parameterdescs{$param_name} = $undescribed;
> +           $parameterdescs{$param} = $undescribed;
>
>             if (($type eq 'function') || ($type eq 'enum')) {
>                 print STDERR "${file}:$.: warning: Function parameter ".
> @@ -2409,6 +2471,7 @@ sub push_parameter($$$) {
>         # "[blah" in a parameter string;
>         ###$param =~ s/\s*//g;
>         push @parameterlist, $param;
> +       $type =~ s/\s\s+/ /g;
>         $parametertypes{$param} = $type;
>  }
>
> @@ -2450,7 +2513,7 @@ sub check_sections($$$$$$) {
>                         } else {
>                                 if ($nested !~ m/\Q$sects[$sx]\E/) {
>                                     print STDERR "${file}:$.: warning: " .
> -                                       "Excess struct/union/enum/typedef
> member " .
> +                                       "Excess $decl_type member " .
>                                         "'$sects[$sx]' " .
>                                         "description in '$decl_name'\n";
>                                     ++$warnings;
> @@ -2505,7 +2568,13 @@ sub dump_function($$) {
>      $prototype =~ s/__must_check +//;
>      $prototype =~ s/__weak +//;
>      my $define = $prototype =~ s/^#\s*define\s+//; #ak added
> -    $prototype =~ s/__attribute__\s*\(\([a-z,]*\)\)//;
> +    $prototype =~ s/__attribute__\s*\(\(
> +            (?:
> +                 [\w\s]++          # attribute name
> +                 (?:\([^)]*+\))?   # attribute arguments
> +                 \s*+,?            # optional comma at the end
> +            )+
> +          \)\)\s+//x;
>
>      # Yes, this truly is vile.  We are looking for:
>      # 1. Return type (may be nothing if we're looking at a macro)
> @@ -2533,21 +2602,21 @@ sub dump_function($$) {
>          $noret = 1;
>      } elsif ($prototype =~ m/^()([a-zA-Z0-9_~:]+)\s*\(([^\(]*)\)/ ||
>         $prototype =~ m/^(\w+)\s+([a-zA-Z0-9_~:]+)\s*\(([^\(]*)\)/ ||
> -       $prototype =~ m/^(\w+\s*\*)\s*([a-zA-Z0-9_~:]+)\s*\(([^\(]*)\)/ ||
> +       $prototype =~ m/^(\w+\s*\*+)\s*([a-zA-Z0-9_~:]+)\s*\(([^\(]*)\)/
> ||
>         $prototype =~ m/^(\w+\s+\w+)\s+([a-zA-Z0-9_~:]+)\s*\(([^\(]*)\)/
> ||
>         $prototype =~ m/^(\w+\s+\w+\s*\*+)\s*([a-zA-Z0-9_~:]+)\s*\(([^\(]*)\)/
> ||
>         $prototype =~ m/^(\w+\s+\w+\s+\w+)\s+([a-zA-Z0-9_~:]+)\s*\(([^\(]*)\)/
> ||
> -       $prototype =~ m/^(\w+\s+\w+\s+\w+\s*\*)\s*([
> a-zA-Z0-9_~:]+)\s*\(([^\(]*)\)/ ||
> +       $prototype =~ m/^(\w+\s+\w+\s+\w+\s*\*+)\s*(
> [a-zA-Z0-9_~:]+)\s*\(([^\(]*)\)/ ||
>         $prototype =~ m/^()([a-zA-Z0-9_~:]+)\s*\(([^\{]*)\)/ ||
>         $prototype =~ m/^(\w+)\s+([a-zA-Z0-9_~:]+)\s*\(([^\{]*)\)/ ||
> -       $prototype =~ m/^(\w+\s*\*)\s*([a-zA-Z0-9_~:]+)\s*\(([^\{]*)\)/ ||
> +       $prototype =~ m/^(\w+\s*\*+)\s*([a-zA-Z0-9_~:]+)\s*\(([^\{]*)\)/
> ||
>         $prototype =~ m/^(\w+\s+\w+)\s+([a-zA-Z0-9_~:]+)\s*\(([^\{]*)\)/
> ||
> -       $prototype =~ m/^(\w+\s+\w+\s*\*)\s*([a-zA-Z0-9_~:]+)\s*\(([^\{]*)\)/
> ||
> +       $prototype =~ m/^(\w+\s+\w+\s*\*+)\s*([a-zA-Z0-9_~:]+)\s*\(([^\{]*)\)/
> ||
>         $prototype =~ m/^(\w+\s+\w+\s+\w+)\s+([a-zA-Z0-9_~:]+)\s*\(([^\{]*)\)/
> ||
> -       $prototype =~ m/^(\w+\s+\w+\s+\w+\s*\*)\s*([
> a-zA-Z0-9_~:]+)\s*\(([^\{]*)\)/ ||
> +       $prototype =~ m/^(\w+\s+\w+\s+\w+\s*\*+)\s*(
> [a-zA-Z0-9_~:]+)\s*\(([^\{]*)\)/ ||
>         $prototype =~ m/^(\w+\s+\w+\s+\w+\s+\w+)\s+(
> [a-zA-Z0-9_~:]+)\s*\(([^\{]*)\)/ ||
> -       $prototype =~ m/^(\w+\s+\w+\s+\w+\s+\w+\s*\*
> )\s*([a-zA-Z0-9_~:]+)\s*\(([^\{]*)\)/ ||
> -       $prototype =~ m/^(\w+\s+\w+\s*\*\s*\w+\s*\*\
> s*)\s*([a-zA-Z0-9_~:]+)\s*\(([^\{]*)\)/)  {
> +       $prototype =~ m/^(\w+\s+\w+\s+\w+\s+\w+\s*\*
> +)\s*([a-zA-Z0-9_~:]+)\s*\(([^\{]*)\)/ ||
> +       $prototype =~ m/^(\w+\s+\w+\s*\*+\s*\w+\s*\*
> +\s*)\s*([a-zA-Z0-9_~:]+)\s*\(([^\{]*)\)/)  {
>         $return_type = $1;
>         $declaration_name = $2;
>         my $args = $3;
> @@ -2705,6 +2774,9 @@ sub process_proto_type($$) {
>
>      while (1) {
>         if ( $x =~ /([^{};]*)([{};])(.*)/ ) {
> +            if( length $prototype ) {
> +                $prototype .= " "
> +            }
>             $prototype .= $1 . $2;
>             ($2 eq '{') && $brcount++;
>             ($2 eq '}') && $brcount--;
> --
> 2.14.3
>
>

--001a114aac8cbd3c1a0562a48ad9
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Applied.<div>Thanks.</div></div><div class=3D"gmail_extra"=
><br><div class=3D"gmail_quote">On Fri, Nov 17, 2017 at 5:54 PM, Xose Vazqu=
ez Perez <span dir=3D"ltr">&lt;<a href=3D"mailto:xose.vazquez@gmail.com" ta=
rget=3D"_blank">xose.vazquez@gmail.com</a>&gt;</span> wrote:<br><blockquote=
 class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1px #ccc soli=
d;padding-left:1ex">Cc: Gris Ge &lt;<a href=3D"mailto:fge@redhat.com">fge@r=
edhat.com</a>&gt;<br>
Cc: Christophe Varoqui &lt;<a href=3D"mailto:christophe.varoqui@opensvc.com=
">christophe.varoqui@opensvc.<wbr>com</a>&gt;<br>
Cc: device-mapper development &lt;<a href=3D"mailto:dm-devel@redhat.com">dm=
-devel@redhat.com</a>&gt;<br>
Signed-off-by: Xose Vazquez Perez &lt;<a href=3D"mailto:xose.vazquez@gmail.=
com">xose.vazquez@gmail.com</a>&gt;<br>
---<br>
=C2=A0libdmmp/docs/kernel-doc | 164 ++++++++++++++++++++++++++++++<wbr>++++=
--------------<br>
=C2=A01 file changed, 118 insertions(+), 46 deletions(-)<br>
<br>
diff --git a/libdmmp/docs/kernel-doc b/libdmmp/docs/kernel-doc<br>
index 8f5b546..7bd52b8 100644<br>
--- a/libdmmp/docs/kernel-doc<br>
+++ b/libdmmp/docs/kernel-doc<br>
@@ -1,5 +1,6 @@<br>
-#!/usr/bin/perl -w<br>
+#!/usr/bin/env perl<br>
<br>
+use warnings;<br>
=C2=A0use strict;<br>
<br>
=C2=A0## Copyright (c) 1998 Michael Zucchi, All Rights Reserved=C2=A0 =C2=
=A0 =C2=A0 =C2=A0 ##<br>
@@ -199,29 +200,36 @@ EOF<br>
=C2=A0# &#39;funcname()&#39; - function<br>
=C2=A0# &#39;$ENVVAR&#39; - environmental variable<br>
=C2=A0# &#39;&amp;struct_name&#39; - name of a structure (up to two words i=
ncluding &#39;struct&#39;)<br>
+# &#39;&amp;struct_name.member&#39; - name of a structure member<br>
=C2=A0# &#39;@parameter&#39; - name of a parameter<br>
=C2=A0# &#39;%CONST&#39; - name of a constant.<br>
+# &#39;``LITERAL``&#39; - literal string without any spaces on it.<br>
<br>
=C2=A0## init lots of data<br>
<br>
-<br>
=C2=A0my $errors =3D 0;<br>
=C2=A0my $warnings =3D 0;<br>
=C2=A0my $anon_struct_union =3D 0;<br>
<br>
=C2=A0# match expressions used to find embedded type information<br>
-my $type_constant =3D &#39;\%([-_\w]+)&#39;;<br>
+my $type_constant =3D &#39;\b``([^\`]+)``\b&#39;;<br>
+my $type_constant2 =3D &#39;\%([-_\w]+)&#39;;<br>
=C2=A0my $type_func =3D &#39;(\w+)\(\)&#39;;<br>
=C2=A0my $type_param =3D &#39;\@(\w+(\.\.\.)?)&#39;;<br>
=C2=A0my $type_fp_param =3D &#39;\@(\w+)\(\)&#39;;=C2=A0 # Special RST hand=
ling for func ptr params<br>
-my $type_struct =3D &#39;\&amp;((struct\s*)*[_\w]+)&#39;;<br>
-my $type_struct_xml =3D &#39;\\&amp;amp;((struct\s*)*[_\w]+)&#39;;<br>
=C2=A0my $type_env =3D &#39;(\$\w+)&#39;;<br>
-my $type_enum_full =3D &#39;\&amp;(enum)\s*([_\w]+)&#39;;<br>
-my $type_struct_full =3D &#39;\&amp;(struct)\s*([_\w]+)&#39;;<br>
-my $type_typedef_full =3D &#39;\&amp;(typedef)\s*([_\w]+)&#39;;<br>
-my $type_union_full =3D &#39;\&amp;(union)\s*([_\w]+)&#39;;<br>
-my $type_member =3D &#39;\&amp;([_\w]+)((\.|-&gt;)[_\w]+)&#39;;<br>
+my $type_enum =3D &#39;\&amp;(enum\s*([_\w]+))&#39;;<br>
+my $type_struct =3D &#39;\&amp;(struct\s*([_\w]+))&#39;;<br>
+my $type_typedef =3D &#39;\&amp;(typedef\s*([_\w]+))&#39;;<br>
+my $type_union =3D &#39;\&amp;(union\s*([_\w]+))&#39;;<br>
+my $type_member =3D &#39;\&amp;([_\w]+)(\.|-&gt;)([_\w]+)&#39;;<br>
+my $type_fallback =3D &#39;\&amp;([_\w]+)&#39;;<br>
+my $type_enum_xml =3D &#39;\&amp;amp;(enum\s*([_\w]+))&#39;;<br>
+my $type_struct_xml =3D &#39;\&amp;amp;(struct\s*([_\w]+))&#39;;<br>
+my $type_typedef_xml =3D &#39;\&amp;amp;(typedef\s*([_\w]+))&#39;;<br>
+my $type_union_xml =3D &#39;\&amp;amp;(union\s*([_\w]+))&#39;;<br>
+my $type_member_xml =3D &#39;\&amp;amp;([_\w]+)(\.|-\&amp;gt;)([_\<wbr>w]+=
)&#39;;<br>
+my $type_fallback_xml =3D &#39;\&amp;amp([_\w]+)&#39;;<br>
=C2=A0my $type_member_func =3D $type_member . &#39;\(\)&#39;;<br>
<br>
=C2=A0# Output conversion substitutions.<br>
@@ -230,10 +238,16 @@ my $type_member_func =3D $type_member . &#39;\(\)&#39=
;;<br>
=C2=A0# these work fairly well<br>
=C2=A0my @highlights_html =3D (<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 [$type_constant, &quot;&lt;i&gt;\$1&lt;/i&gt;&quot;],<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0[$type_constant2, &quot;&lt;i&gt;\$1&lt;/i&gt;&quot;],<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 [$type_func, &quot;&lt;b&gt;\$1&lt;/b&gt;&quot;],<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0[$type_enum_xml, &quot;&lt;i&gt;\$1&lt;/i&gt;&quot;],<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 [$type_struct_xml, &quot;&lt;i&gt;\$1&lt;/i&gt;&quot;],<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0[$type_typedef_xml, &quot;&lt;i&gt;\$1&lt;/i&gt;&quot;],<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0[$type_union_xml, &quot;&lt;i&gt;\$1&lt;/i&gt;&quot;],<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 [$type_env, &quot;&lt;b&gt;&lt;i&gt;\$1&lt;/i&gt;&lt;/b&gt;&quot=
;],<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0[$type_param, &quot;&lt;tt&gt;&lt;b&gt;\$1&lt;/b&gt;&lt;/tt&gt;&q=
uot;]<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0[$type_param, &quot;&lt;tt&gt;&lt;b&gt;\$1&lt;/b&gt;&lt;/tt&gt;&q=
uot;],<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0[$type_member_xml, &quot;&lt;tt&gt;&lt;i&gt;\$1&lt;/i&gt;\$2\$3&l=
t;/tt&gt;&quot;],<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0[$type_fallback_xml, &quot;&lt;i&gt;\$1&lt;/i&gt;&quot;]<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0);<br>
=C2=A0my $local_lt =3D &quot;\\\\\\\\lt:&quot;;<br>
=C2=A0my $local_gt =3D &quot;\\\\\\\\gt:&quot;;<br>
@@ -242,10 +256,16 @@ my $blankline_html =3D $local_lt . &quot;p&quot; . $l=
ocal_gt; # was &quot;&lt;p&gt;&quot;<br>
=C2=A0# html version 5<br>
=C2=A0my @highlights_html5 =3D (<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0[$type_constant, &quot;&lt;span class=3D\&quot;const\&quot=
;&gt;\$1&lt;/span&gt;&quot;],<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 [$type_constant2, &quot;&lt;span class=3D\&quot;const\&quot;&gt;=
\$1&lt;/span&gt;&quot;],<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0[$type_func, &quot;&lt;span class=3D\&quot;func\&quot;&gt;=
\$1&lt;/span&gt;&quot;],<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 [$type_enum_xml, &quot;&lt;span class=3D\&quot;enum\&quot;&gt;\$=
1&lt;/span&gt;&quot;],<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0[$type_struct_xml, &quot;&lt;span class=3D\&quot;struct\&q=
uot;&gt;\$1&lt;/span&gt;&quot;],<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 [$type_typedef_xml, &quot;&lt;span class=3D\&quot;typedef\&quot;=
&gt;\$1&lt;/span&gt;&quot;]<wbr>,<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 [$type_union_xml, &quot;&lt;span class=3D\&quot;union\&quot;&gt;=
\$1&lt;/span&gt;&quot;],<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0[$type_env, &quot;&lt;span class=3D\&quot;env\&quot;&gt;\$=
1&lt;/span&gt;&quot;],<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 [$type_param, &quot;&lt;span class=3D\&quot;param\&quot;&gt;\$1&=
lt;/span&gt;]&quot;]<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 [$type_param, &quot;&lt;span class=3D\&quot;param\&quot;&gt;\$1&=
lt;/span&gt;]&quot;],<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 [$type_member_xml, &quot;&lt;span class=3D\&quot;literal\&quot;&=
gt;&lt;span class=3D\&quot;struct\&quot;&gt;\$1&lt;/span&gt;\$<wbr>2&lt;spa=
n class=3D\&quot;member\&quot;&gt;\$3&lt;/span&gt;&lt;/<wbr>span&gt;&quot;]=
,<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 [$type_fallback_xml, &quot;&lt;span class=3D\&quot;struct\&quot;=
&gt;\$1&lt;/span&gt;&quot;]<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0);<br>
=C2=A0my $blankline_html5 =3D $local_lt . &quot;br /&quot; . $local_gt;<br>
<br>
@@ -253,55 +273,80 @@ my $blankline_html5 =3D $local_lt . &quot;br /&quot; =
. $local_gt;<br>
=C2=A0my @highlights_xml =3D (<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0[&quot;([^=3D])\\\&quot;([^\\\&quot;&lt;]+)\\\&quot;&quot;, &quot=
;\$1&lt;quote&gt;\$2&lt;/quote&gt;&quot;],<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0[$type_constant, &quot;&lt;constant&gt;\$1&lt;/constant&gt;&quot;=
],<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 [$type_constant2, &quot;&lt;constant&gt;\$1&lt;/constant&gt;&quot;],<br=
>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 [$type_enum_xml, &quot;&lt;type&gt;\$1&lt;/type&gt;&quot;],<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0[$type_struct_xml, &quot;&lt;structname&gt;\$1&lt;/structname&gt;=
&quot;<wbr>],<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 [$type_typedef_xml, &quot;&lt;type&gt;\$1&lt;/type&gt;&quot;],<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 [$type_union_xml, &quot;&lt;structname&gt;\$1&lt;/structname&gt;&quot;<=
wbr>],<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0[$type_param, &quot;&lt;parameter&gt;\$1&lt;/parameter&gt;&quot;]=
,<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0[$type_func, &quot;&lt;function&gt;\$1&lt;/function&gt;&quot;],<b=
r>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 [$type_env, &quot;&lt;envar&gt;\$1&lt;/envar&gt;&quot;]<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 [$type_env, &quot;&lt;envar&gt;\$1&lt;/envar&gt;&quot;],<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 [$type_member_xml, &quot;&lt;literal&gt;&lt;structname&gt;\$1&lt;/<wbr>=
structname&gt;\$2&lt;structfield&gt;\$<wbr>3&lt;/structfield&gt;&lt;/litera=
l&gt;&quot;],<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 [$type_fallback_xml, &quot;&lt;structname&gt;\$1&lt;/structname&gt;&quo=
t;<wbr>]<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0);<br>
=C2=A0my $blankline_xml =3D $local_lt . &quot;/para&quot; . $local_gt . $lo=
cal_lt . &quot;para&quot; . $local_gt . &quot;\n&quot;;<br>
<br>
=C2=A0# gnome, docbook format<br>
=C2=A0my @highlights_gnome =3D (<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0[$type_constant, &quot;&lt;replaceable class=3D\&quot;opti=
on\&quot;&gt;\$1&lt;/<wbr>replaceable&gt;&quot;],<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 [$type_constant2, &quot;&lt;replaceable class=3D\&quot;option\&q=
uot;&gt;\$1&lt;/<wbr>replaceable&gt;&quot;],<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0[$type_func, &quot;&lt;function&gt;\$1&lt;/function&gt;&qu=
ot;],<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 [$type_enum, &quot;&lt;type&gt;\$1&lt;/type&gt;&quot;],<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0[$type_struct, &quot;&lt;structname&gt;\$1&lt;/structname&=
gt;&quot;<wbr>],<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 [$type_typedef, &quot;&lt;type&gt;\$1&lt;/type&gt;&quot;],<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 [$type_union, &quot;&lt;structname&gt;\$1&lt;/structname&gt;&quo=
t;<wbr>],<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0[$type_env, &quot;&lt;envar&gt;\$1&lt;/envar&gt;&quot;],<b=
r>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 [$type_param, &quot;&lt;parameter&gt;\$1&lt;/parameter&gt;&quot;=
 ]<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 [$type_param, &quot;&lt;parameter&gt;\$1&lt;/parameter&gt;&quot;=
 ],<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 [$type_member, &quot;&lt;literal&gt;&lt;structname&gt;\$1&lt;/<w=
br>structname&gt;\$2&lt;structfield&gt;\$<wbr>3&lt;/structfield&gt;&lt;/lit=
eral&gt;&quot;],<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 [$type_fallback, &quot;&lt;structname&gt;\$1&lt;/structname&gt;&=
quot;<wbr>]<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0);<br>
=C2=A0my $blankline_gnome =3D &quot;&lt;/para&gt;&lt;para&gt;\n&quot;;<br>
<br>
=C2=A0# these are pretty rough<br>
=C2=A0my @highlights_man =3D (<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0[$type_constant, &quot;\$1&quot;],<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 [$type_constant2, &quot;\$1&quot;],<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0[$type_func, &quot;\\\\fB\$1\\\\fP&quot;],<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 [$type_enum, &quot;\\\\fI\$1\\\\fP&quot;],<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0[$type_struct, &quot;\\\\fI\$1\\\\fP&quot;],<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 [$type_param, &quot;\\\\fI\$1\\\\fP&quot;]<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 [$type_typedef, &quot;\\\\fI\$1\\\\fP&quot;],<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 [$type_union, &quot;\\\\fI\$1\\\\fP&quot;],<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 [$type_param, &quot;\\\\fI\$1\\\\fP&quot;],<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 [$type_member, &quot;\\\\fI\$1\$2\$3\\\\fP&quot;],<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 [$type_fallback, &quot;\\\\fI\$1\\\\fP&quot;]<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0);<br>
=C2=A0my $blankline_man =3D &quot;&quot;;<br>
<br>
=C2=A0# text-mode<br>
=C2=A0my @highlights_text =3D (<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 [$type_constant, &quot;\$1&quot;],<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0[$type_constant2, &quot;\$1&quot;],<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 [$type_func, &quot;\$1&quot;],<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0[$type_enum, &quot;\$1&quot;],<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 [$type_struct, &quot;\$1&quot;],<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0[$type_param, &quot;\$1&quot;]<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0[$type_typedef, &quot;\$1&quot;],<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0[$type_union, &quot;\$1&quot;],<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0[$type_param, &quot;\$1&quot;],<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0[$type_member, &quot;\$1\$2\$3&quot;],<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0[$type_fallback, &quot;\$1&quot;]<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 );<br>
=C2=A0my $blankline_text =3D &quot;&quot;;<br>
<br>
=C2=A0# rst-mode<br>
=C2=A0my @highlights_rst =3D (<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 [$type_constant, &quot;``\$1``&quot;],<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0[$type_constant2, &quot;``\$1``&quot;],<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 # Note: need to escape () to avoid func matching later<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0[$type_member_func, &quot;\\:c\\:type\\:`\$1\$2\\\\(\\\<wbr>\) &l=
t;\$1&gt;`&quot;],<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0[$type_member, &quot;\\:c\\:type\\:`\$1\$2 &lt;\$1&gt;`&quot;],<b=
r>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0[$type_member_func, &quot;\\:c\\:type\\:`\$1\$2\$3\\\\(<wbr>\\\\)=
 &lt;\$1&gt;`&quot;],<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0[$type_member, &quot;\\:c\\:type\\:`\$1\$2\$3 &lt;\$1&gt;`&quot;]=
,<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0[$type_fp_param, &quot;**\$1\\\\(\\\\)**&quot;],<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 [$type_func, &quot;\\:c\\:func\\:`\$1()`&quot;],<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0[$type_struct_full, &quot;\\:c\\:type\\:`\$1 \$2 &lt;\$2&gt;`&quo=
t;],<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0[$type_enum_full, &quot;\\:c\\:type\\:`\$1 \$2 &lt;\$2&gt;`&quot;=
],<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0[$type_typedef_full, &quot;\\:c\\:type\\:`\$1 \$2 &lt;\$2&gt;`&qu=
ot;],<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0[$type_union_full, &quot;\\:c\\:type\\:`\$1 \$2 &lt;\$2&gt;`&quot=
;],<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0[$type_enum, &quot;\\:c\\:type\\:`\$1 &lt;\$2&gt;`&quot;],<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0[$type_struct, &quot;\\:c\\:type\\:`\$1 &lt;\$2&gt;`&quot;],<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0[$type_typedef, &quot;\\:c\\:type\\:`\$1 &lt;\$2&gt;`&quot;],<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0[$type_union, &quot;\\:c\\:type\\:`\$1 &lt;\$2&gt;`&quot;],<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 # in rst this can refer to any type<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0[$type_struct, &quot;\\:c\\:type\\:`\$1`&quot;],<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0[$type_fallback, &quot;\\:c\\:type\\:`\$1`&quot;],<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 [$type_param, &quot;**\$1**&quot;]<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 );<br>
=C2=A0my $blankline_rst =3D &quot;\n&quot;;<br>
@@ -309,9 +354,15 @@ my $blankline_rst =3D &quot;\n&quot;;<br>
=C2=A0# list mode<br>
=C2=A0my @highlights_list =3D (<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 [$type_constant, &quot;\$1&quot;],<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0[$type_constant2, &quot;\$1&quot;],<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 [$type_func, &quot;\$1&quot;],<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0[$type_enum, &quot;\$1&quot;],<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 [$type_struct, &quot;\$1&quot;],<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0[$type_param, &quot;\$1&quot;]<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0[$type_typedef, &quot;\$1&quot;],<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0[$type_union, &quot;\$1&quot;],<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0[$type_param, &quot;\$1&quot;],<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0[$type_member, &quot;\$1&quot;],<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0[$type_fallback, &quot;\$1&quot;]<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 );<br>
=C2=A0my $blankline_list =3D &quot;&quot;;<br>
<br>
@@ -414,7 +465,7 @@ my $doc_com =3D &#39;\s*\*\s*&#39;;<br>
=C2=A0my $doc_com_body =3D &#39;\s*\* ?&#39;;<br>
=C2=A0my $doc_decl =3D $doc_com . &#39;(\w+)&#39;;<br>
=C2=A0# @params and a strictly limited set of supported section names<br>
-my $doc_sect =3D $doc_com .<br>
+my $doc_sect =3D $doc_com .<br>
=C2=A0 =C2=A0 =C2=A0&#39;\s*(\@[.\w]+|\@\.\.\.|<wbr>description|context|ret=
urns?|<wbr>notes?|examples?)\s*:(.*)&#39;;<br>
=C2=A0my $doc_content =3D $doc_com_body . &#39;(.*)&#39;;<br>
=C2=A0my $doc_block =3D $doc_com . &#39;DOC:\s*(.*)?&#39;;<br>
@@ -1131,8 +1182,9 @@ sub output_function_xml(%) {<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 foreach $parameter (@{$args{&#39;parameterlist&=
#39;}}) {<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 my $parameter_name =3D $parameter=
;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 $parameter_name =3D~ s/\[.*//;<br=
>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0$type =3D $args{&#39;parametertyp=
es&#39;}{$<wbr>parameter};<br>
<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0print &quot;=C2=A0 &lt;varlistent=
ry&gt;\n=C2=A0 =C2=A0&lt;term&gt;&lt;parameter&gt;$parameter&lt;/<wbr>param=
eter&gt;&lt;/term&gt;\n&quot;;<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0print &quot;=C2=A0 &lt;varlistent=
ry&gt;\n=C2=A0 =C2=A0&lt;term&gt;&lt;parameter&gt;$type $parameter&lt;/para=
meter&gt;&lt;/term&gt;\<wbr>n&quot;;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 print &quot;=C2=A0 =C2=A0&lt;list=
item&gt;\n=C2=A0 =C2=A0 &lt;para&gt;\n&quot;;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 $lineprefix=3D&quot;=C2=A0 =C2=A0=
 =C2=A0&quot;;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 output_highlight($args{&#39;<wbr>=
parameterdescs&#39;}{$parameter_<wbr>name});<br>
@@ -1223,8 +1275,9 @@ sub output_struct_xml(%) {<br>
<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0defined($args{&#39;parameterdescs&#39;<wbr>}{$pa=
rameter_name}) || next;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0($args{&#39;parameterdescs&#39;}{$<wbr>parameter=
_name} ne $undescribed) || next;<br>
+=C2=A0 =C2=A0 =C2=A0 $type =3D $args{&#39;parametertypes&#39;}{$<wbr>param=
eter};<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0print &quot;=C2=A0 =C2=A0 &lt;varlistentry&gt;&q=
uot;;<br>
-=C2=A0 =C2=A0 =C2=A0 print &quot;=C2=A0 =C2=A0 =C2=A0 &lt;term&gt;$paramet=
er&lt;/term&gt;\n&quot;;<br>
+=C2=A0 =C2=A0 =C2=A0 print &quot;=C2=A0 =C2=A0 =C2=A0 &lt;term&gt;&lt;lite=
ral&gt;$type $parameter&lt;/literal&gt;&lt;/term&gt;\n&quot;<wbr>;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0print &quot;=C2=A0 =C2=A0 =C2=A0 &lt;listitem&gt=
;&lt;para&gt;\n&quot;;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0output_highlight($args{&#39;<wbr>parameterdescs&=
#39;}{$parameter_<wbr>name});<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0print &quot;=C2=A0 =C2=A0 =C2=A0 &lt;/para&gt;&l=
t;/listitem&gt;\n&quot;;<br>
@@ -1883,7 +1936,7 @@ sub output_function_rst(%) {<br>
=C2=A0 =C2=A0 =C2=A0$lineprefix =3D &quot;=C2=A0 &quot;;<br>
=C2=A0 =C2=A0 =C2=A0foreach $parameter (@{$args{&#39;parameterlist&#39;}}) =
{<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 my $parameter_name =3D $parameter;<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0#$parameter_name =3D~ s/\[.*//;<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0$parameter_name =3D~ s/\[.*//;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 $type =3D $args{&#39;parametertypes&#39;}{$<wbr=
>parameter};<br>
<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 if ($type ne &quot;&quot;) {<br>
@@ -2115,7 +2168,7 @@ sub dump_struct($$) {<br>
=C2=A0 =C2=A0 =C2=A0my $nested;<br>
<br>
=C2=A0 =C2=A0 =C2=A0if ($x =3D~ /(struct|union)\s+(\w+)\s*{(.*<wbr>)}/) {<b=
r>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0#my $decl_type =3D $1;<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0my $decl_type =3D $1;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 $declaration_name =3D $2;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 my $members =3D $3;<br>
<br>
@@ -2129,17 +2182,17 @@ sub dump_struct($$) {<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 # strip comments:<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 $members =3D~ s/\/\*.*?\*\///gos;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 $nested =3D~ s/\/\*.*?\*\///gos;<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0# strip kmemcheck_bitfield_{begin,end}<wbr>.*;<=
br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0$members =3D~ s/kmemcheck_bitfield_.*?;//<wbr>g=
os;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 # strip attributes<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 $members =3D~ s/__attribute__\s*\(\([a-z,_\*<wb=
r>\s\(\)]*\)\)//i;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 $members =3D~ s/__aligned\s*\([^;]*\)//gos;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 $members =3D~ s/\s*CRYPTO_MINALIGN_ATTR//<wbr>g=
os;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 # replace DECLARE_BITMAP<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 $members =3D~ s/DECLARE_BITMAP\s*\(([^,)]+), ([=
^,)]+)\)/unsigned long $1\[BITS_TO_LONGS($2)\]/gos;<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0# replace DECLARE_HASHTABLE<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0$members =3D~ s/DECLARE_HASHTABLE\s*\(([^,)]<wb=
r>+), ([^,)]+)\)/unsigned long $1\[1 &lt;&lt; (($2) - 1)\]/gos;<br>
<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 create_parameterlist($members, &#39;;&#39;, $fi=
le);<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0check_sections($file, $declaration_name, &quot;=
struct&quot;, $sectcheck, $struct_actual, $nested);<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0check_sections($file, $declaration_name, $decl_=
type, $sectcheck, $struct_actual, $nested);<br>
<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 output_declaration($<wbr>declaration_name,<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0&#39;struct&#39;,<br>
@@ -2171,6 +2224,9 @@ sub dump_enum($$) {<br>
=C2=A0 =C2=A0 =C2=A0if ($x =3D~ /enum\s+(\w+)\s*{(.*)}/) {<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 $declaration_name =3D $1;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 my $members =3D $2;<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0my %_members;<br>
+<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0$members =3D~ s/\s+$//;<br>
<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 foreach my $arg (split &#39;,&#39;, $members) {=
<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 $arg =3D~ s/^\s*(\w+).*/$1/;<br>
@@ -2180,9 +2236,16 @@ sub dump_enum($$) {<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 print STDERR &quot;=
${file}:$.: warning: Enum value &#39;$arg&#39; &quot;.<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 &quot=
;not described in enum &#39;$declaration_name&#39;\n&quot;;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 }<br>
-<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0$_members{$arg} =3D 1;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 }<br>
<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0while (my ($k, $v) =3D each %parameterdescs) {<=
br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if (!exists($_members{$k})) {<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 print STDERR &quot;${file}:$.: w=
arning: Excess enum value &quot; .<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0&quot;&#39;$k&#39; description in &#39;$declaration_name&#=
39;\n&quot;;<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0}<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 }<br>
+<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 output_declaration($<wbr>declaration_name,<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0&#39;enum&#39;,<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0{&#39;enum&#39; =3D&gt; $declaration_name,<br>
@@ -2350,8 +2413,7 @@ sub push_parameter($$$) {<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 }<br>
<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 $anon_struct_union =3D 0;<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0my $param_name =3D $param;<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0$param_name =3D~ s/\[.*//;<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0$param =3D~ s/[\[\)].*//;<br>
<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 if ($type eq &quot;&quot; &amp;&amp; $param =3D=
~ /\.\.\.$/)<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 {<br>
@@ -2382,9 +2444,9 @@ sub push_parameter($$$) {<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 # but inline preprocessor statements);<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 # also ignore unnamed structs/unions;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 if (!$anon_struct_union) {<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0if (!defined $parameterdescs{$param_name} &amp;=
&amp; $param_name !~ /^#/) {<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0if (!defined $parameterdescs{$param} &amp;&amp;=
 $param !~ /^#/) {<br>
<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0$parameterdescs{$param_name} =3D =
$undescribed;<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0$parameterdescs{$param} =3D $unde=
scribed;<br>
<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (($type eq &#39;function&#39;)=
 || ($type eq &#39;enum&#39;)) {<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 print STDERR &quot;=
${file}:$.: warning: Function parameter &quot;.<br>
@@ -2409,6 +2471,7 @@ sub push_parameter($$$) {<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 # &quot;[blah&quot; in a parameter string;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 ###$param =3D~ s/\s*//g;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 push @parameterlist, $param;<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0$type =3D~ s/\s\s+/ /g;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 $parametertypes{$param} =3D $type;<br>
=C2=A0}<br>
<br>
@@ -2450,7 +2513,7 @@ sub check_sections($$$$$$) {<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 } else {<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if ($nested !~ m/\Q$sects[$sx]\E/) {=
<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 print STDERR &quot;${f=
ile}:$.: warning: &quot; .<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0&quot;Exc=
ess struct/union/enum/typedef member &quot; .<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0&quot;Exc=
ess $decl_type member &quot; .<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 &quot;&#=
39;$sects[$sx]&#39; &quot; .<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 &quot;de=
scription in &#39;$decl_name&#39;\n&quot;;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 ++$warnings;<br>
@@ -2505,7 +2568,13 @@ sub dump_function($$) {<br>
=C2=A0 =C2=A0 =C2=A0$prototype =3D~ s/__must_check +//;<br>
=C2=A0 =C2=A0 =C2=A0$prototype =3D~ s/__weak +//;<br>
=C2=A0 =C2=A0 =C2=A0my $define =3D $prototype =3D~ s/^#\s*define\s+//; #ak =
added<br>
-=C2=A0 =C2=A0 $prototype =3D~ s/__attribute__\s*\(\([a-z,]*\<wbr>)\)//;<br=
>
+=C2=A0 =C2=A0 $prototype =3D~ s/__attribute__\s*\(\(<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 (?:<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0[\w\s]++=C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 # attribute name<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0(?:\([^)]*+\=
))?=C2=A0 =C2=A0# attribute arguments<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0\s*+,?=C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 # optional comma at the end<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 )+<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 \)\)\s+//x;<br>
<br>
=C2=A0 =C2=A0 =C2=A0# Yes, this truly is vile.=C2=A0 We are looking for:<br=
>
=C2=A0 =C2=A0 =C2=A0# 1. Return type (may be nothing if we&#39;re looking a=
t a macro)<br>
@@ -2533,21 +2602,21 @@ sub dump_function($$) {<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0$noret =3D 1;<br>
=C2=A0 =C2=A0 =C2=A0} elsif ($prototype =3D~ m/^()([a-zA-Z0-9_~:]+)\s*\(([^=
<wbr>\(]*)\)/ ||<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 $prototype =3D~ m/^(\w+)\s+([a-zA-Z0-9_~:]+)\<w=
br>s*\(([^\(]*)\)/ ||<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0$prototype =3D~ m/^(\w+\s*\*)\s*([a-zA-Z0-9_~:<=
wbr>]+)\s*\(([^\(]*)\)/ ||<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0$prototype =3D~ m/^(\w+\s*\*+)\s*([a-zA-Z0-9_~<=
wbr>:]+)\s*\(([^\(]*)\)/ ||<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 $prototype =3D~ m/^(\w+\s+\w+)\s+([a-zA-Z0-9_~<=
wbr>:]+)\s*\(([^\(]*)\)/ ||<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 $prototype =3D~ m/^(\w+\s+\w+\s*\*+)\s*([a-zA-<=
wbr>Z0-9_~:]+)\s*\(([^\(]*)\)/ ||<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 $prototype =3D~ m/^(\w+\s+\w+\s+\w+)\s+([a-zA-<=
wbr>Z0-9_~:]+)\s*\(([^\(]*)\)/ ||<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0$prototype =3D~ m/^(\w+\s+\w+\s+\w+\s*\*)\s*([<=
wbr>a-zA-Z0-9_~:]+)\s*\(([^\(]*)\)<wbr>/ ||<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0$prototype =3D~ m/^(\w+\s+\w+\s+\w+\s*\*+)\s*(<=
wbr>[a-zA-Z0-9_~:]+)\s*\(([^\(]*)\<wbr>)/ ||<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 $prototype =3D~ m/^()([a-zA-Z0-9_~:]+)\s*\(([^<=
wbr>\{]*)\)/ ||<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 $prototype =3D~ m/^(\w+)\s+([a-zA-Z0-9_~:]+)\<w=
br>s*\(([^\{]*)\)/ ||<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0$prototype =3D~ m/^(\w+\s*\*)\s*([a-zA-Z0-9_~:<=
wbr>]+)\s*\(([^\{]*)\)/ ||<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0$prototype =3D~ m/^(\w+\s*\*+)\s*([a-zA-Z0-9_~<=
wbr>:]+)\s*\(([^\{]*)\)/ ||<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 $prototype =3D~ m/^(\w+\s+\w+)\s+([a-zA-Z0-9_~<=
wbr>:]+)\s*\(([^\{]*)\)/ ||<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0$prototype =3D~ m/^(\w+\s+\w+\s*\*)\s*([a-zA-<w=
br>Z0-9_~:]+)\s*\(([^\{]*)\)/ ||<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0$prototype =3D~ m/^(\w+\s+\w+\s*\*+)\s*([a-zA-<=
wbr>Z0-9_~:]+)\s*\(([^\{]*)\)/ ||<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 $prototype =3D~ m/^(\w+\s+\w+\s+\w+)\s+([a-zA-<=
wbr>Z0-9_~:]+)\s*\(([^\{]*)\)/ ||<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0$prototype =3D~ m/^(\w+\s+\w+\s+\w+\s*\*)\s*([<=
wbr>a-zA-Z0-9_~:]+)\s*\(([^\{]*)\)<wbr>/ ||<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0$prototype =3D~ m/^(\w+\s+\w+\s+\w+\s*\*+)\s*(<=
wbr>[a-zA-Z0-9_~:]+)\s*\(([^\{]*)\<wbr>)/ ||<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 $prototype =3D~ m/^(\w+\s+\w+\s+\w+\s+\w+)\s+(<=
wbr>[a-zA-Z0-9_~:]+)\s*\(([^\{]*)\<wbr>)/ ||<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0$prototype =3D~ m/^(\w+\s+\w+\s+\w+\s+\w+\s*\*<=
wbr>)\s*([a-zA-Z0-9_~:]+)\s*\(([^\<wbr>{]*)\)/ ||<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0$prototype =3D~ m/^(\w+\s+\w+\s*\*\s*\w+\s*\*\<=
wbr>s*)\s*([a-zA-Z0-9_~:]+)\s*\(([<wbr>^\{]*)\)/)=C2=A0 {<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0$prototype =3D~ m/^(\w+\s+\w+\s+\w+\s+\w+\s*\*<=
wbr>+)\s*([a-zA-Z0-9_~:]+)\s*\(([^<wbr>\{]*)\)/ ||<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0$prototype =3D~ m/^(\w+\s+\w+\s*\*+\s*\w+\s*\*<=
wbr>+\s*)\s*([a-zA-Z0-9_~:]+)\s*\(<wbr>([^\{]*)\)/)=C2=A0 {<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 $return_type =3D $1;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 $declaration_name =3D $2;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 my $args =3D $3;<br>
@@ -2705,6 +2774,9 @@ sub process_proto_type($$) {<br>
<br>
=C2=A0 =C2=A0 =C2=A0while (1) {<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 if ( $x =3D~ /([^{};]*)([{};])(.*)/ ) {<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if( length $prototype ) {<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 $prototype .=3D &q=
uot; &quot;<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 }<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 $prototype .=3D $1 . $2;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 ($2 eq &#39;{&#39;) &amp;&amp; $b=
rcount++;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 ($2 eq &#39;}&#39;) &amp;&amp; $b=
rcount--;<br>
<span class=3D"HOEnZb"><font color=3D"#888888">--<br>
2.14.3<br>
<br>
</font></span></blockquote></div><br></div>

--001a114aac8cbd3c1a0562a48ad9--


--===============8012034701324078916==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============8012034701324078916==--
